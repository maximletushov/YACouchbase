//
//  Box.h
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface Box : CBLModel

+ (NSString *)docType;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *created;

@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) NSArray *photos;

@end
