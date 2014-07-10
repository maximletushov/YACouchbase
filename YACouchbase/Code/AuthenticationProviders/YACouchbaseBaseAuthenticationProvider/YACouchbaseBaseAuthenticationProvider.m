//
//  YACouchbaseBaseAuthenticationProvider.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseBaseAuthenticationProvider.h"
#import <CouchbaseLite/CBLAuthenticator.h>

@implementation YACouchbaseBaseAuthenticationProvider

- (id<CBLAuthenticator>)authenticator
{
    return [CBLAuthenticator basicAuthenticatorWithName:self.name password:self.password];
}

- (void)authenticateAgainAndProvideAuthenticator:(void(^)(id<CBLAuthenticator> authenticator))callback
{
    /*
     Using Base HTTP Authentication session can be invalid only when password changed, so application can't recreate credentials without user.
     */
    
    if (self.UnauthorizedHandler) {
        self.UnauthorizedHandler();
    }
}

@end
