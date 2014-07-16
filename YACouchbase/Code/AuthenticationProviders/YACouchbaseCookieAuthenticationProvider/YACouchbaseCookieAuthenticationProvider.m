//
//  YACouchbaseCookieAuthenticationProvider.m
//  YACouchbase
//
//  Created by Maxim on 7/14/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseCookieAuthenticationProvider.h"
#import "YACouchbaseCookieStorage.h"

@implementation YACouchbaseCookieAuthenticationProvider

#pragma mark -
#pragma mark Class methods

+ (BOOL)hasCookieForURL:(NSURL *)url
{
    return [[YACouchbaseCookieStorage shared] hasCookieForURL:url];
}

#pragma mark -
#pragma mark Initializers

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithCookieName:(NSString *)cookieName
                         sessionID:(NSString *)sessionID
                    expirationDate:(NSDate *)expirationDate
                               url:(NSURL *)url
{
    self = [self init];
    if (self) {
        //delete all previously stored cookies for a given url
        [[YACouchbaseCookieStorage shared] deleteAllCookiesForURL:url];
        
        //setup a new NSHTTPCookie object
        NSDictionary *cookieProperties = @{NSHTTPCookieDomain: [url host],
                                           NSHTTPCookiePath: [url path],
                                           NSHTTPCookieName : cookieName,
                                           NSHTTPCookieValue : sessionID,
                                           NSHTTPCookieExpires : expirationDate};
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        
        //store NSHTTPCookie
        [[YACouchbaseCookieStorage shared] setCookie:cookie];
    }
    return self;
}

@end
