//
//  YAReplicator.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseReplicator.h"
#import "YACouchbaseNotificationCenter.h"
#import "YACouchbaseDefines.h"

static NSString *const kStatus = @"status";
static NSString *const kLastError = @"lastError";
static NSString *const kCompletedChangesCount = @"completedChangesCount";
static NSString *const kChangesCount = @"changesCount";


@interface YACouchbaseReplicator ()

@property (nonatomic, weak) YACouchbase *couchbase;
@property (nonatomic, strong) NSURL *syncURL;
@property (nonatomic, strong) NSError *lastSyncError;
@property (nonatomic, strong) CBLReplication *pull;
@property (nonatomic, strong) CBLReplication *push;
@property (nonatomic, strong) id<YACouchbaseAuthProvider> authenticatorProvider;

@end


@implementation YACouchbaseReplicator

- (instancetype)initWithCouchbase:(YACouchbase *)couchbase
                          syncURL:(NSURL *)syncURL
            authenticatorProvider:(id<YACouchbaseAuthProvider>)authenticatorProvider
{
    NSAssert(couchbase.database, @"You should provide database for replication");
    NSAssert(syncURL, @"You should provide sync URL for replication");
    NSAssert(authenticatorProvider, @"You should provide authenticator for replication");

    self = [super init];
    if (self) {
        self.couchbase = couchbase;
        self.syncURL = syncURL;
        self.authenticatorProvider = authenticatorProvider;
        
        [self createReplications];
        
        [self startObserving];
    }
    return self;
}

- (void)dealloc
{
    [self stopObserving];
}

- (void)createReplications
{
    self.pull = [self.couchbase.database createPullReplication:self.syncURL];
    self.pull.continuous = YES;
    
    self.push = [self.couchbase.database createPushReplication:self.syncURL];
    self.push.continuous = YES;
    
    [self setupAuthorizationForReplications];
}

- (void)setupAuthorizationForReplications
{
    [self.authenticatorProvider provideAuthenticationForReplication:self.pull];
    [self.authenticatorProvider provideAuthenticationForReplication:self.push];
}

#pragma mark -
#pragma mark Start / Stop / Restart

- (void)startReplication
{
    [self.pull start];
    [self.push start];
}

- (void)stopReplication
{
    [self.pull stop];
    [self.push stop];
}

- (void)restartReplication
{
    [self stopReplication];
    [self startReplication];
}

#pragma mark -
#pragma mark Observing

- (void)startObserving
{
    [self startReplicationObserving:self.pull];
    [self startReplicationObserving:self.push];
}

- (void)stopObserving
{
    [self stopReplicationObserving:self.pull];
    [self stopReplicationObserving:self.push];
}

- (void)startReplicationObserving:(CBLReplication *)replication
{
    NSKeyValueObservingOptions options = (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
    
    [replication addObserver:self forKeyPath:kStatus options:options context:nil];
    [replication addObserver:self forKeyPath:kLastError options:options context:nil];
    [replication addObserver:self forKeyPath:kCompletedChangesCount options:options context:nil];
    [replication addObserver:self forKeyPath:kChangesCount options:options context:nil];
}

- (void)stopReplicationObserving:(CBLReplication *)replication
{
    [replication removeObserver:self forKeyPath:kStatus context:nil];
    [replication removeObserver:self forKeyPath:kLastError context:nil];
    [replication removeObserver:self forKeyPath:kCompletedChangesCount context:nil];
    [replication removeObserver:self forKeyPath:kChangesCount context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.pull || object == self.push) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        
        if (![newValue isEqual:oldValue]) {
            if ([keyPath isEqualToString:kStatus]) {
                if ([(NSNumber *)newValue integerValue] == kCBLReplicationActive) {
                    [self.couchbase.couchbaseNotificationCenter replicationDidStart:object];
                } else if ([(NSNumber *)newValue integerValue] == kCBLReplicationIdle) {
                    [self.couchbase.couchbaseNotificationCenter replicationDidFinish:object];
                }
            } else if ([keyPath isEqualToString:kLastError]) {
                if (newValue) {
                    [self handleReplicationError:newValue];
                }
            } else if ([keyPath isEqualToString:kCompletedChangesCount] || [keyPath isEqualToString:kChangesCount]) {
                CBLReplication *replication = (CBLReplication *)object;
                
                unsigned completed = replication.completedChangesCount;
                unsigned total = replication.changesCount;
                double progress = (completed / (float) MAX(1u, total));
                
                [self.couchbase.couchbaseNotificationCenter replication:replication progressChanged:progress total:total completed:completed];
            }
        }
    }
}

#pragma mark -
#pragma mark Handling of HTTP errors and other errors

- (void)handleReplicationError:(NSError *)error
{    
    if (![error isKindOfClass:[NSError class]]) {
        return;
    }

    if (error == self.lastSyncError) {
        return ;
    }
    
    if (!error) {
        return;
    }
    
    self.lastSyncError = error;
    
    if (error.code == YACouchbaseHTTPResponseCode.unauthorized_401) {
        [self stopReplication];
        
        YACouchbaseReplicator *weakSelf __weak = self;
        
        [self.authenticatorProvider handleUnauthorizedErrorWithCallback:^(BOOL shouldReaskAuthenticationAndRestartReplication) {
            if (shouldReaskAuthenticationAndRestartReplication) {
                [weakSelf setupAuthorizationForReplications];
                [weakSelf startReplication];
            }
        }];
        
    } else if (error.code == YACouchbaseHTTPResponseCode.internalServerError_500) {
        NSLog(@"Error occured in sync function on Sync Gateway. Check your sync function.");
        //TODO:
    } else if (error.code == YACouchbaseHTTPResponseCode.forbidden_403) {
        //TODO:        
        NSLog(@"Sync function on Sync Gateway has called 'forbidden' for document during synchronization. Check your sync function.");
    }
}

@end
