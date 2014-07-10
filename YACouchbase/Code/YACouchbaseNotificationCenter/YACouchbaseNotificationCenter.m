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

@property (nonatomic, strong) NSMutableArray *replicationObservers;

@end


@implementation YACouchbaseNotificationCenter

- (NSMutableArray *)replicationObservers
{
    if (!_replicationObservers) {
        _replicationObservers = [NSMutableArray new];
    }
    return _replicationObservers;
}

- (void)addReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver database:(CBLDatabase *)database
{
    if (!replicationObserver) {
        return;
    }
    
    if (NSNotFound == [self indexOfReplicationObserverObject:replicationObserver]) {
        [self.replicationObservers addObject:@{kObject: replicationObserver, kDatabase: database}];
    };
}

- (void)removeReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver database:(CBLDatabase *)database
{
    if (!replicationObserver) {
        return;
    }
    
    NSInteger index = [self indexOfReplicationObserverObject:replicationObserver];
    if (NSNotFound != index) {
        [self.replicationObservers removeObjectAtIndex:index];
    }
}

- (NSInteger)indexOfReplicationObserverObject:(id<YACouchbaseReplicationObserver>)replicationObserver
{
    return [self indexOfObject:(id)replicationObserver inArray:self.replicationObservers];
}

- (NSInteger)indexOfObject:(id)object inArray:(NSArray *)array
{
    NSInteger count = array.count;
    for (int i = 0; i < count; i++) {
        NSDictionary *dict = array[i];
        if (dict[kObject] == object) {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark -

- (void)replicationDidStart:(CBLReplication *)replication
{
    for (NSDictionary *dict in self.replicationObservers) {
        id<YACouchbaseReplicationObserver> observer = dict[kObject];
        CBLDatabase *database = dict[kDatabase];
        
        if (replication.localDatabase == database) {
            [observer replicationDidStart:replication];
        }
    }
}

- (void)replicationDidFinish:(CBLReplication *)replication
{
    for (NSDictionary *dict in self.replicationObservers) {
        id<YACouchbaseReplicationObserver> observer = dict[kObject];
        CBLDatabase *database = dict[kDatabase];
        
        if (replication.localDatabase == database) {
            [observer replicationDidFinish:replication];
        }
    }
}

- (void)replication:(CBLReplication *)replication progressChanged:(double)progress total:(unsigned)total completed:(unsigned)completed
{
    for (NSDictionary *dict in self.replicationObservers) {
        id<YACouchbaseReplicationObserver> observer = dict[kObject];
        CBLDatabase *database = dict[kDatabase];
        
        if (replication.localDatabase == database) {
            [observer replication:replication progressChanged:progress total:total completed:completed];
        }
    }
}

@end
