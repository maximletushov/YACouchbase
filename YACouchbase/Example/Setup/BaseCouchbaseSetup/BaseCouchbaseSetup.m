//
//  BaseCouchbaseSetup.m
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "BaseCouchbaseSetup.h"
#import "Box.h"

@implementation BaseCouchbaseSetup

- (void)logoutUser
{

}

- (void)setupModels
{
    CBLView *boxesView = [self.couchbase.database viewNamed:@"boxes"];
    
    NSString *docType = [Box docType];
    [boxesView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString:docType]) {
            NSString *title = doc[@"title"];
            emit(@[title], doc);
        }
    }) version: @"1.1"];
    
    [self.couchbase.database.modelFactory registerClass:Box.class forDocumentType:@"box"];
}

@end
