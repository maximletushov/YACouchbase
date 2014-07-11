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
 Used to setup authorization for replication, like Basic Authentication, Cookie, Facebook token and so on...
 */

- (void)provideAuthenticationForReplication:(CBLReplication *)replication;

/**
 Used to re ask authenticator when 401 HTTP error faced.
 There are 2 scenarious how to handle this situation
 
 Scenario 1:
    Step 1 : take in someway new credetials (for example facebook token)
    Step 2: create new authenticator and call callback with input value equal to YES
 
 Scenario 2:
    Step 1: Call callback input value equal to NO
    Step 2: Close database
    Step 3: Log Out user
    Step 4: Provid Login UI
    Step 5: Open database again after login
 */

- (void)handleUnauthorizedErrorWithCallback:(void(^)(BOOL shouldReaskAuthenticationAndRestartReplication))callback;

@end
