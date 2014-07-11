//
//  YAViewController.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAViewController.h"
#import "YACouchbase.h"
#import "YACouchbaseBaseAuthenticationProvider.h"
#import "YACouchbaseConflictsResolutionCenter.h"
#import "YACouchbaseNotificationCenter.h"

static NSString *const kUserName = @"name";
static NSString *const kUserPassword = @"password";


@interface YAViewController () <YACouchbaseReplicationObserver>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YACouchbase *couchbase;
@property (nonatomic, strong) YACouchbaseBaseAuthenticationProvider *authenticationProvider;
@property (nonatomic, strong) NSArray *users;

@end


@implementation YAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.users = @[@{kUserName : @"user1", kUserPassword : @"password1"},
                   @{kUserName : @"user2", kUserPassword : @"password2"}];
}

- (IBAction)loginUser1:(id)sender
{
    [self loginUser:self.users[0]];
}

- (IBAction)loginUser2:(id)sender
{
    [self loginUser:self.users[1]];
}

- (void)loginUser:(NSDictionary *)user
{
    if (self.couchbase) {
        [self logoutUser:nil];
    }
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:4984/test_db"];
    
    YAViewController *weakSelf __weak = self;
    
    self.authenticationProvider = [[YACouchbaseBaseAuthenticationProvider alloc] initWithName:user[kUserName]
                                                                                     password:user[kUserPassword]];
    self.authenticationProvider.UnauthorizedHandler = ^{
//        NSLog(@"401 error");
        //[weakSelf logoutUser:nil];
    };
    
    NSError *error = nil;
    
    self.couchbase = [[YACouchbase alloc] init];
    [self.couchbase openDatabaseWithName:user[kUserName] syncURL:url authenticatorProvider:self.authenticationProvider error:error];
    if (error) {
        exit(-1);
    }
    
    [self.couchbase.couchbaseNotificationCenter addReplicationObserver:self];
    
    [self.couchbase startReplication];
}

- (IBAction)logoutUser:(id)sender
{
    [self.couchbase closeDatabase];
    self.couchbase = nil;
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
