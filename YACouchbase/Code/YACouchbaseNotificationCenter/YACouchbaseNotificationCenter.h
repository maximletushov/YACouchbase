//
//  YACouchbaseNotificationCenter.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YACouchbaseReplicationObserver.h"

/* Used for:
 - Provide place for register observers for notification events
 */


@interface YACouchbaseNotificationCenter : NSObject <YACouchbaseReplicationObserver>

- (void)addReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver database:(CBLDatabase *)database;
- (void)removeReplicationObserver:(id<YACouchbaseReplicationObserver>)replicationObserver database:(CBLDatabase *)database;

@end
