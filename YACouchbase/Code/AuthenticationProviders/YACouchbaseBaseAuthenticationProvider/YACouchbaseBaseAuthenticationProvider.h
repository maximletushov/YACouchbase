//
//  YACouchbaseBaseAuthenticationProvider.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthenticatorProvider.h"

@interface YACouchbaseBaseAuthenticationProvider : NSObject <YACouchbaseAuthenticatorProvider>

@property (nonatomic, copy) void(^UnauthorizedHandler)(void);

- (instancetype)initWithName:(NSString *)name password:(NSString *)password;

- (NSString *)authorizationHeaderValue;

@end
