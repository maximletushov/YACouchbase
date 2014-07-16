//
//  BasicAuthenticationSetup.h
//  YACouchbase
//
//  Created by Maxim on 7/15/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicAuthenticationSetup : NSObject

- (void)setupWithUserName:(NSString *)username password:(NSString *)password syncURL:(NSURL *)syncURL;

- (void)logoutUser;

@end
