//
//  BasicAuthenticationSetup.m
//  YACouchbase
//
//  Created by Maxim on 7/15/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "BasicAuthenticationSetup.h"

@interface BasicAuthenticationSetup () <YACouchbaseReplicationObserver>

@property (nonatomic, strong) YACouchbase *couchbase;
@property (nonatomic, strong) YACouchbaseBasicAuthenticationProvider *authenticationProvider;

@end


@implementation BasicAuthenticationSetup

- (void)setupWithUserName:(NSString *)username password:(NSString *)password syncURL:(NSURL *)syncURL
{
    if (self.couchbase) {
        [self logoutUser];
    }
    
    BasicAuthenticationSetup *weakSelf __weak = self;
    
    self.authenticationProvider = [[YACouchbaseBasicAuthenticationProvider alloc] initWithName:username
                                                                                      password:password];
    self.authenticationProvider.UnauthorizedHandler = ^{
        [weakSelf logoutUser];
    };
    
    NSError *error = nil;
    
    self.couchbase = [[YACouchbase alloc] init];
    [self.couchbase openDatabaseWithName:username syncURL:syncURL authenticatorProvider:self.authenticationProvider error:error];
    if (error) {
        exit(-1);
    }
    
    [self.couchbase.couchbaseNotificationCenter addReplicationObserver:self];
    
    [self setupModels];
    
    [self.couchbase startReplication];
}

- (void)logoutUser
{
    [self.couchbase closeDatabase];
    self.couchbase = nil;
    self.authenticationProvider = nil;
}

#pragma mark -
#pragma mark YACouchbaseReplicationObserver

- (void)replicationDidStart:(CBLReplication *)replication
{
    NSLog(@"replication start");
}

- (void)replicationDidFinish:(CBLReplication *)replication
{
    NSLog(@"replication finish");
}

- (void)replication:(CBLReplication *)replication progressChanged:(double)progress total:(unsigned)total completed:(unsigned)completed
{
    NSLog(@"replication progress=%f total=%i completed=%i", progress, total, completed);
}

@end
