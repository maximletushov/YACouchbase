//
//  YACouchbaseCookieAuthenticationProvider.h
//  YACouchbase
//
//  Created by Maxim on 7/14/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthenticationProvider.h"

@interface YACouchbaseCookieAuthenticationProvider : YACouchbaseAuthenticationProvider

/* Method tries to use already saved cookie for configuring CBLReplication
 */
- (instancetype)init;

/* Method will configure cookie with input parameters and save them, so in the next time you can use just init method.
 */
- (instancetype)initWithCookieName:(NSString *)cookieName
                         sessionID:(NSString *)sessionID
                    expirationDate:(NSDate *)expirationDate
                               url:(NSURL *)url;

+ (BOOL)hasCookieForURL:(NSURL *)url;

@end
