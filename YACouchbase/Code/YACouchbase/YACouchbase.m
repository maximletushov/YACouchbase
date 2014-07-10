//
//  YACouchbase.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbase.h"
#import "YACouchbaseReplicator.h"

@interface YACouchbase ()

@property (nonatomic, strong) CBLManager *manager;
@property (nonatomic, strong) CBLDatabase *database;
@property (nonatomic, strong) YACouchbaseReplicator *replicator;
@property (nonatomic, strong) YACouchbaseConflictsResolutionCenter *conflictsResolutionCenter;
@property (nonatomic, strong) YACouchbaseNotificationCenter *couchbaseNotificationCenter;

@end


@implementation YACouchbase

- (void)openDatabaseWithName:(NSString *)dbname
                     syncURL:(NSURL *)url
       authenticatorProvider:(id<YACouchbaseAuthenticatorProvider>)authenticatorProvider
                       error:(NSError *)error
{
    error = nil;
    
    NSAssert(!self.database, @"You can't open database because someone is already opened");
    NSAssert(authenticatorProvider, @"You should provide authenticator for replication");
    
    self.manager = [CBLManager sharedInstance];
    
    self.database = [self.manager databaseNamed:dbname error:&error];
    if (error) {
        NSLog(@"error getting database %@",error);
        return ;
    }
    
    self.couchbaseNotificationCenter = [YACouchbaseNotificationCenter new];

    self.conflictsResolutionCenter = [[YACouchbaseConflictsResolutionCenter alloc] initWithDatabase:self.database];
    
    self.replicator = [[YACouchbaseReplicator alloc] initWithCouchbase:self syncURL:url authenticatorProvider:authenticatorProvider];
}

- (void)closeDatabase
{
    [self.replicator stopReplication];
    [self.manager close];
    
    self.manager = nil;
    self.database = nil;
    self.replicator = nil;
    self.conflictsResolutionCenter = nil;
    self.couchbaseNotificationCenter = nil;
}

- (void)startReplication
{
    [self.replicator startReplication];
}

- (void)stopReplication
{
    [self.replicator stopReplication];
}

#pragma mark -
#pragma mark Accessors

- (CBLReplication *)pull
{
    return self.replicator.pull;
}

- (CBLReplication *)push
{
    return self.replicator.push;
}


@end
