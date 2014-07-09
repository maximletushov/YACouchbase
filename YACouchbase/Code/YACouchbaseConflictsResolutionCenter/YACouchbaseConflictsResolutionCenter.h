//
//  YACouchbaseConflictsResolutionCenter.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseConflictsSolver.h"

@interface YACouchbaseConflictsResolutionCenter : NSObject

- (instancetype)initWithDatabase:(CBLDatabase *)database;

- (void)registerConflictsSolver:(id<YACouchbaseConflictsSolver>)solver forDocumentType:(NSString*)type;

- (id<YACouchbaseConflictsSolver>)conflictsSolverForDocumentType:(NSString *)type;

@end
