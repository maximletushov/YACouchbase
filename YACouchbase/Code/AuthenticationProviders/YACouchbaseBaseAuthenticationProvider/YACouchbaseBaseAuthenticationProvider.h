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

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, copy) void(^UnauthorizedHandler)(void);

@end
