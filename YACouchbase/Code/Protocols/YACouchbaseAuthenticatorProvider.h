//
//  YACouchbaseAuthenticatorProvider.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@protocol YACouchbaseAuthenticatorProvider <NSObject>

@required

/**
 Used to give authenticator to start replication
 */
- (id<CBLAuthenticator>)authenticator;

/**
 Used to re ask authenticator when 401 HTTP error faced.
 You should log in again in order to renew session and then call callback with new authenticator
 */
- (void)authenticateAgainAndProvideAuthenticator:(void(^)(id<CBLAuthenticator> authenticator))callback;

@end
