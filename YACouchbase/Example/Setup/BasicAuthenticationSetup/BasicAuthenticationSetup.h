//
//  BasicAuthenticationSetup.h
//  YACouchbase
//
//  Created by Maxim on 7/15/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCouchbaseSetup.h"

@interface BasicAuthenticationSetup : BaseCouchbaseSetup

- (void)setupWithUserName:(NSString *)username password:(NSString *)password syncURL:(NSURL *)syncURL;

@end
