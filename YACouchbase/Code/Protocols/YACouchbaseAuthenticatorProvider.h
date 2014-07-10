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

/**
 Used to give authenticator to start replication
 */
- (id<CBLAuthenticator>)authenticator;

/**
 Used to re ask authenticator when 401 HTTP error faced.
 There are 2 scenarious how to handle this situation
 
 Scenario 1:
    Step 1 : take in someway new credetials (for example facebook token)
    Step 2: create new authenticator and call callback
 
 Scenario 2:
    Step 1: Forgot about callback (not use it)
    Step 2: Close database
    Step 3: Log Out user
    Step 4: Provid Login UI
    Step 5: Open database again after login
 
 You should log in again in order to renew session and then call callback with new authenticator
 In implementation in is possible to not call callback because you can just logout user and when it login again then recreate hole database.
 */
- (void)authenticateAgainAndProvideAuthenticator:(void(^)(id<CBLAuthenticator> authenticator))callback;

@end
