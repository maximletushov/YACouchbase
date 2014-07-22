//
//  YAViewController.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YAViewController.h"
#import "YACouchbase.h"
#import "BasicAuthenticationSetup.h"
#import "CookieAuthenticationSetup.h"
#import "YACouchbaseCookieAuthenticationProvider.h"
#import "ChangeBoxViewController.h"
#import "BoxesViewController.h"

static NSString *const kSyncURL = @"http://localhost:4984/test_db";
static NSString *const kSessionURL = @"http://localhost:4985/test_db/_session";

static NSString *const kUserName = @"name";
static NSString *const kUserPassword = @"password";

static NSString *const kUser3 = @"user3";

@interface YAViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *user1Button;
@property (weak, nonatomic) IBOutlet UIButton *user2Button;
@property (weak, nonatomic) IBOutlet UIButton *user3Button;
@property (weak, nonatomic) IBOutlet UIButton *user3ButtonTwo;

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) BasicAuthenticationSetup *basicAuthenticationSetup;
@property (nonatomic, strong) CookieAuthenticationSetup *cookieAuthenticationSetup;

@end


@implementation YAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.users = @[@{kUserName : @"user1", kUserPassword : @"password1"},
                   @{kUserName : @"user2", kUserPassword : @"password2"}];
    
    [self userDidLogout];
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
    [self userWillLogin];
    
    self.basicAuthenticationSetup = [BasicAuthenticationSetup new];
    [self.basicAuthenticationSetup setupWithUserName:user[kUserName] password:user[kUserPassword] syncURL:[NSURL URLWithString:kSyncURL]];
    
    [self userDidLogin];
    
    [self performSegueWithIdentifier:@"boxes" sender:self.basicAuthenticationSetup];
}

- (IBAction)loginUser3:(id)sender
{
    [self userWillLogin];
    
    YAViewController *weakSelf __weak = self;
    [CookieAuthenticationSetup createSessionForUserName:kUser3
                                             sessionURL:[NSURL URLWithString:kSessionURL]
                                         successHandler:^(NSString *cookieName, NSString *sessionID, NSDate *expirationDate) {

                                             weakSelf.cookieAuthenticationSetup = [CookieAuthenticationSetup new];

                                             [weakSelf.cookieAuthenticationSetup setupWithSyncUrl:[NSURL URLWithString:kSyncURL]
                                                                                         username:kUser3
                                                                                       cookieName:cookieName
                                                                                        sessionID:sessionID
                                                                                   expirationDate:expirationDate];

                                             [weakSelf userDidLogin];
                                             
                                             [weakSelf performSegueWithIdentifier:@"boxes" sender:weakSelf.cookieAuthenticationSetup];
    } errorHandler:^(NSError *error) {
        NSLog(@"%@", error);
        
        [self userDidLogout];
    }];
}

- (IBAction)loginUser3WithAlreadyStoredCookie:(id)sender
{
    NSURL *url = [NSURL URLWithString:kSyncURL];

    if (![YACouchbaseCookieAuthenticationProvider hasCookieForURL:url]) {
        NSLog(@"You should not provide cookie data if you already did, for examle in previous application launch calling loginUser3");

        [self userDidLogout];
        return ;
    }
    
    self.cookieAuthenticationSetup = [CookieAuthenticationSetup new];
    [self.cookieAuthenticationSetup setupWithSyncUrl:url
                                            username:kUser3];
    [self userDidLogin];
}

- (void)userWillLogin
{
    self.user1Button.enabled = NO;
    self.user2Button.enabled = NO;
    self.user3Button.enabled = NO;
    self.user3ButtonTwo.enabled = NO;
}

- (void)userDidLogin
{
    self.user1Button.enabled = NO;
    self.user2Button.enabled = NO;
    self.user3Button.enabled = NO;
    self.user3ButtonTwo.enabled = NO;
}

- (void)userDidLogout
{
    self.user1Button.enabled = YES;
    self.user2Button.enabled = YES;
    self.user3Button.enabled = YES;
    self.user3ButtonTwo.enabled = YES;
}

#pragma mark -
#pragma mark

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YAViewController *weakSelf __weak = self;
    
    if ([segue.identifier isEqualToString:@"boxes"]) {
        BoxesViewController *vc = segue.destinationViewController;
        vc.UserDidLogout = ^{
            [weakSelf.basicAuthenticationSetup logoutUser];
            [weakSelf.cookieAuthenticationSetup logoutUser];
            
            weakSelf.cookieAuthenticationSetup = nil;
            weakSelf.basicAuthenticationSetup = nil;
            
            [weakSelf userDidLogout];
        };
        
        vc.setup = sender;
    }
}

@end
