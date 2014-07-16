//
//  YACouchbase.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthProvider.h"
#import "YACouchbaseConflictsResolutionCenter.h"
#import "YACouchbaseNotificationCenter.h"

@class YACouchbaseReplicator;
@interface YACouchbase : NSObject

@property (nonatomic, strong, readonly) CBLManager *manager;
@property (nonatomic, strong, readonly) CBLDatabase *database;
@property (nonatomic, strong, readonly) CBLReplication *pull;
@property (nonatomic, strong, readonly) CBLReplication *push;
@property (nonatomic, strong, readonly) YACouchbaseConflictsResolutionCenter *conflictsResolutionCenter;
@property (nonatomic, strong, readonly) YACouchbaseNotificationCenter *couchbaseNotificationCenter;

@property (nonatomic, assign) BOOL clearCookiesForSyncURLWhenCloseDatabase;  //default is YES

- (void)openDatabaseWithName:(NSString *)dbname
                     syncURL:(NSURL *)url
       authenticatorProvider:(id<YACouchbaseAuthProvider>)authenticatorProvider
                       error:(NSError *)error;

- (void)closeDatabase;

- (void)startReplication;
- (void)stopReplication;

@end
