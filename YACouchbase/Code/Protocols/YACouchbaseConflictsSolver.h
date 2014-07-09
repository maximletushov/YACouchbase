//
//  YACouchbaseConflictsSolver.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YACouchbaseConflictsSolver <NSObject>

@optional
- (void)solveConflictsWithDatabaseChange:(CBLDatabaseChange *)change;
- (void)solveConflictsInDocument:(CBLDocument *)document;

@end
