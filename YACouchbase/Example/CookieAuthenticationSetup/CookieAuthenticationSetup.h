//
//  CookieAuthenticationSetup.h
//  YACouchbase
//
//  Created by Maxim on 7/15/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
  This example setup demonstrates how to setup couchbase with cookie authentication.
 */

@interface CookieAuthenticationSetup : NSObject

/*
 This method can be useful when you test couchbase sync on your LOCAL MASHINE !!!
 
 Couchbase sync refuses creation of session when it is situated on remote mashine.
 Commonly server side should create sessions when you implement custom authentication with backend.
 */

+ (void)createSessionForUserName:(NSString *)username
                      sessionURL:(NSURL *)sessionURL
                  successHandler:(void(^)(NSString *cookieName, NSString *sessionID, NSDate *expirationDate))successHandler
                    errorHandler:(void(^)(NSError *error))errorHandler;

/*
 
 */

+ (NSDate *)expirationDateFromString:(NSString *)string;    //string that was returned from admin authentication API

- (void)setupWithSyncUrl:(NSURL *)syncUrl
                username:(NSString *)username;

- (void)setupWithSyncUrl:(NSURL *)syncUrl
                username:(NSString *)username
              cookieName:(NSString *)cookieName
               sessionID:(NSString *)sessionID
          expirationDate:(NSDate *)expirationDate;



- (void)logoutUser;

@end
