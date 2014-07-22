//
//  Box.m
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "Box.h"

@implementation Box

@dynamic type;
@dynamic owner;
@dynamic title;
@dynamic created;
@dynamic channels;
@dynamic photos;

+ (NSString *)docType
{
    return @"box";
}

- (instancetype)initWithDocument:(CBLDocument *)document
{
    self = [super initWithDocument: document];
    if (self) {
    }
    return self;
}

- (void)willSave:(NSSet *)changedPropertyNames
{
    //method is called right before a save
}

- (NSDictionary *)propertiesToSaveForDeletion {
    NSMutableDictionary* props = [[super propertiesToSaveForDeletion] mutableCopy];
// here we can add some properties to the "tombstone" revision
//    props[@"timestamp"] = [CBLJSON JSONObjectWithDate: [NSDate date]];
    return props;
}

@end
