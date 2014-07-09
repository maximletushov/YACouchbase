//
//  YACouchbaseReplicationObserver.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@protocol YACouchbaseReplicationObserver <NSObject>

@optional
- (void)replicationDidStart:(CBLReplication *)replication;
- (void)replicationDidFinish:(CBLReplication *)replication;
- (void)replication:(CBLReplication *)replication progressChanged:(double)progress total:(unsigned)total completed:(unsigned)completed;

@end
