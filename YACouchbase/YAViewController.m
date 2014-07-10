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

@interface YAViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YACouchbase *couchbase;
@property (nonatomic, strong) YACouchbaseBaseAuthenticationProvider *authenticationProvider;
@end

@implementation YAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loginUser1:(id)sender
{
    NSString *const username = @"user1";
    NSURL *url = [NSURL URLWithString:@"http://localhost:4985/sync_gateway"];
    
    self.authenticationProvider = [YACouchbaseBaseAuthenticationProvider new];
    self.authenticationProvider.name = @"";
    self.authenticationProvider.password = @"";
    
    NSError *error = nil;
    
    YACouchbase *couchbase = [[YACouchbase alloc] init];
    [couchbase openDatabaseWithName:username syncURL:url authenticatorProvider:self.authenticationProvider error:error];
}

- (IBAction)loginUser2:(id)sender
{
    
}

- (IBAction)logoutUser:(id)sender
{
    
}
@end
