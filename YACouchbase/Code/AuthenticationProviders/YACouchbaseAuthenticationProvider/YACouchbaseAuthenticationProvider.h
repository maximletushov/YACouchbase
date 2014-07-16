//
//  YACouchbaseAuthenticationProvider.h
//  YACouchbase
//
//  Created by Maxim on 7/14/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthProvider.h"

/*
 Class implements <YACouchbaseAuthProvider> with the following rules:
 method -provideAuthenticationForReplication do nothing
 method -handleUnauthorizedErrorWithCallback calls UnauthorizedHandler
 */

@interface YACouchbaseAuthenticationProvider : NSObject <YACouchbaseAuthProvider>

- (void)addHTTPRequestHeader:(NSString *)header
                   withValue:(NSString *)value
               toReplication:(CBLReplication *)replication;

@property (nonatomic, copy) void(^UnauthorizedHandler)(void);

@end
