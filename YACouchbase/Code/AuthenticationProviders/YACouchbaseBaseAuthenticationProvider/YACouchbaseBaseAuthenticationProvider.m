//
//  YACouchbaseBaseAuthenticationProvider.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseBaseAuthenticationProvider.h"
#import <CouchbaseLite/CBLAuthenticator.h>
#import "YACouchbaseDefines.h"


@interface YACouchbaseBaseAuthenticationProvider ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end


@implementation YACouchbaseBaseAuthenticationProvider

- (instancetype)initWithName:(NSString *)name password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = name;
        self.password = password;
    }
    return self;
}

- (void)provideAuthenticationForReplication:(CBLReplication *)replication
{
    NSMutableDictionary *headers = nil;
    if (replication.headers) {
        headers = [NSMutableDictionary dictionaryWithDictionary:replication.headers];
    } else {
        headers = [NSMutableDictionary dictionary];
    }
    
    headers[YACouchbaseHTTPRequestHeader.authorization] = [self authorizationHeaderValue];
    
    replication.headers = headers;
}

- (NSString *)authorizationHeaderValue
{
	NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    
    NSData *rawData = [basicAuthCredentials dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [rawData base64EncodedStringWithOptions:0];
    
    return [NSString stringWithFormat:@"Basic %@", base64String];
}

- (void)handleUnauthorizedErrorWithCallback:(void(^)(BOOL shouldReaskAuthenticationAndRestartReplication))callback
{
    /*
     Using Basic HTTP Authentication session can be invalid only when password changed, so application can't recreate credentials without user.
     */

    if (callback) {
        callback(NO);
    }
    
    if (self.UnauthorizedHandler) {
        self.UnauthorizedHandler();
    }
}

@end
