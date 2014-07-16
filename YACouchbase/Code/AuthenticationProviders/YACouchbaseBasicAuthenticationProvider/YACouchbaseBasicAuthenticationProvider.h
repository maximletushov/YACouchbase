//
//  YACouchbaseBaseAuthenticationProvider.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthProvider.h"
#import "YACouchbaseAuthenticationProvider.h"

@interface YACouchbaseBasicAuthenticationProvider : YACouchbaseAuthenticationProvider

- (instancetype)initWithName:(NSString *)name password:(NSString *)password;

- (NSString *)authorizationHeaderValue;

@end
