//
//  YACouchbaseAuthenticationProvider.m
//  YACouchbase
//
//  Created by Maxim on 7/14/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseAuthenticationProvider.h"

@implementation YACouchbaseAuthenticationProvider

- (void)provideAuthenticationForReplication:(CBLReplication *)replication
{

}

- (void)handleUnauthorizedErrorWithCallback:(void(^)(BOOL shouldReaskAuthenticationAndRestartReplication))callback
{
    if (callback) {
        callback(NO);
    }
    
    if (self.UnauthorizedHandler) {
        self.UnauthorizedHandler();
    }
}

- (void)addHTTPRequestHeader:(NSString *)header
                   withValue:(NSString *)value
               toReplication:(CBLReplication *)replication
{
    NSMutableDictionary *headers = nil;
    if (replication.headers) {
        headers = [NSMutableDictionary dictionaryWithDictionary:replication.headers];
    } else {
        headers = [NSMutableDictionary dictionary];
    }
    
    headers[header] = value;
    
    replication.headers = headers;
}

@end
