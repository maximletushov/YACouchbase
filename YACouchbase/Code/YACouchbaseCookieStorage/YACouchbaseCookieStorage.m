//
//  YACouchbaseCookieStorage.h
//  YACouchbase
//
//  Created by Maxim on 7/16/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseCookieStorage.h"

@implementation YACouchbaseCookieStorage

+ (instancetype)shared
{
    static YACouchbaseCookieStorage *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YACouchbaseCookieStorage new];
    });
    return shared;
}

- (void)setCookie:(NSHTTPCookie *)cookie
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [cookieStorage setCookie:cookie];
}

- (void)deleteAllCookiesForURL:(NSURL *)url
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [self cookiesForURL:url];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

- (NSArray *)cookiesForURL:(NSURL *)url
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    return [cookieStorage cookiesForURL:url];
}

- (BOOL)hasCookieForURL:(NSURL *)url
{
    return ([self cookiesForURL:url].count != 0);
}

@end
