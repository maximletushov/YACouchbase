//
//  YAReplicator.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthenticatorProvider.h"
#import "YACouchbase.h"


/* Used for:
 - Wrap replication logic
 - Provide YACouchbaseNotificationCenter with replication events
 - Handle errors including authentication errors
 */

@class YACouchbase;

@interface YACouchbaseReplicator : NSObject

@property (nonatomic, strong, readonly) NSURL *syncURL;
@property (nonatomic, strong, readonly) CBLReplication *pull;
@property (nonatomic, strong, readonly) CBLReplication *push;
@property (nonatomic, strong, readonly) id<YACouchbaseAuthenticatorProvider> authenticatorProvider;

- (instancetype)initWithCouchbase:(YACouchbase *)couchbase
                          syncURL:(NSURL *)syncURL
            authenticatorProvider:(id<YACouchbaseAuthenticatorProvider>)authenticatorProvider;

- (void)startReplication;
- (void)stopReplication;

@end
