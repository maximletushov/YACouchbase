//
//  BaseCouchbaseSetup.h
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YACouchbaseLite.h"

@interface BaseCouchbaseSetup : NSObject

@property (nonatomic, strong) YACouchbase *couchbase;

- (void)logoutUser;

- (void)setupModels;

@end
