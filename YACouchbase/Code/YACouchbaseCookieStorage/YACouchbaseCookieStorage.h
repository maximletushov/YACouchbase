//
//  YACouchbaseCookieStorage.h
//  YACouchbase
//
//  Created by Maxim on 7/16/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YACouchbaseCookieStorage : NSObject

+ (instancetype)shared;

- (void)setCookie:(NSHTTPCookie *)cookie;
- (void)deleteAllCookiesForURL:(NSURL *)url;

- (NSArray *)cookiesForURL:(NSURL *)url;
- (BOOL)hasCookieForURL:(NSURL *)url;

@end
