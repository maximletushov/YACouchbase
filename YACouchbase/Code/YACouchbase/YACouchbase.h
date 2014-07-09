//
//  YACouchbase.h
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "YACouchbaseAuthenticatorProvider.h"
#import "YAReplicator.h"

@interface YACouchbase : NSObject

@property (nonatomic, strong, readonly) CBLManager *manager;
@property (nonatomic, strong, readonly) CBLDatabase *database;
@property (nonatomic, strong, readonly) CBLReplication *pull;
@property (nonatomic, strong, readonly) CBLReplication *push;

- (void)openDatabaseWithName:(NSString *)dbname
                     syncURL:(NSURL *)url
       authenticatorProvider:(id<YACouchbaseAuthenticatorProvider>)authenticatorProvider
                       error:(NSError *)error;

- (void)closeDatabase;

- (void)startReplication;
- (void)stopReplication;

@end
