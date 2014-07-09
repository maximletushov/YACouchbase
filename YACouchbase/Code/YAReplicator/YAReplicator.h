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

/* Used for:
 - Wrap replication logic
 - Provide YACouchbaseNotificationCenter with replication events
 - Handle authentication and other errors
 */

@interface YAReplicator : NSObject

@property (nonatomic, strong, readonly) NSURL *syncURL;
@property (nonatomic, strong, readonly) CBLReplication *pull;
@property (nonatomic, strong, readonly) CBLReplication *push;
@property (nonatomic, strong, readonly) id<YACouchbaseAuthenticatorProvider> authenticatorProvider;

- (instancetype)initWithDatabase:(CBLDatabase *)database
                         syncURL:(NSURL *)syncURL
           authenticatorProvider:(id<YACouchbaseAuthenticatorProvider>)authenticatorProvider;

- (void)startReplication;
- (void)stopReplication;

@end
