//
//  YACouchbaseNotificationCenter.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseNotificationCenter.h"

static NSString *const kObject = @"object";
static NSString *const kDatabase = @"database";


@interface YACouchbaseNotificationCenter ()

@property (nonatomic, weak) CBLDatabase *database;
@property (nonatomic, strong) NSMutableArray *replicationObservers;

@end


@implementation YACouchbaseNotificationCenter

- (instancetype)initWithDatabase:(CBLDatabase *)database
{
    self = [super init];
    if (self) {
        self.database = database;
    }
    return self;
}

- (NSMutableArray *)replicationObservers
{
    if (!_replicationObservers) {
        _replicationObservers = [NSMutableArray new];
    }
    return _replicationObservers;
}

- (void)addReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver
{
    if (!replicationObserver) {
        return;
    }
    
    if (NSNotFound == [self.replicationObservers indexOfObject:replicationObserver]) {
        [self.replicationObservers addObject:replicationObserver];
    };
}

- (void)removeReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver
{
    if (!replicationObserver) {
        return;
    }
    
    NSInteger index = [self.replicationObservers indexOfObject:replicationObserver];
    if (NSNotFound != index) {
        [self.replicationObservers removeObjectAtIndex:index];
    }
}

#pragma mark -

- (void)replicationDidStart:(CBLReplication *)replication
{
    for (id<YACouchbaseReplicationObserver> observer in self.replicationObservers) {
        [observer replicationDidStart:replication];
    }
}

- (void)replicationDidFinish:(CBLReplication *)replication
{
    for (id<YACouchbaseReplicationObserver> observer in self.replicationObservers) {
        [observer replicationDidFinish:replication];
    }
}

- (void)replication:(CBLReplication *)replication progressChanged:(double)progress total:(unsigned)total completed:(unsigned)completed
{
    for (id<YACouchbaseReplicationObserver> observer in self.replicationObservers) {
        [observer replication:replication progressChanged:progress total:total completed:completed];
    }
}

@end
