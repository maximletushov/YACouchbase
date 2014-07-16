//
//  CookieAuthenticationSetup.m
//  YACouchbase
//
//  Created by Maxim on 7/15/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "CookieAuthenticationSetup.h"
#import "YACouchbaseLite.h"
#import "YACouchbaseDefines.h"

static NSString *const kCookieName = @"cookie_name";
static NSString *const kSessionID = @"session_id";
static NSString *const kExpiration = @"expires";

static NSString *const kHTTPPost = @"POST";

static NSString *const kName = @"name";

static NSString *const kAppJSONContentType = @"application/json";

static NSString *const kCouchbaseDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ";

@interface CookieAuthenticationSetup () <YACouchbaseReplicationObserver>

@property (nonatomic, strong) YACouchbase *couchbase;
@property (nonatomic, strong) YACouchbaseCookieAuthenticationProvider *authenticationProvider;

@end


@implementation CookieAuthenticationSetup

+ (void)createSessionForUserName:(NSString *)username
                      sessionURL:(NSURL *)sessionURL
                  successHandler:(void(^)(NSString *cookieName, NSString *sessionID, NSDate *expirationDate))successHandler
                    errorHandler:(void(^)(NSError *error))errorHandler
{
    NSError *error = nil;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sessionURL];
    [request setHTTPMethod:kHTTPPost];
    [request addValue:kAppJSONContentType forHTTPHeaderField:YACouchbaseHTTPGeneralHeader.contentType];
    
    NSDictionary *params = @{kName:username};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:bodyData];
    
    void(^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (successHandler) {
                NSDate *expirationDate = [self expirationDateFromString:dictionary[kExpiration]];
                successHandler(dictionary[kCookieName], dictionary[kSessionID], expirationDate);
            }
        } else {
            if (errorHandler) {
                errorHandler(error);
            }
        }
    };
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

+ (NSDate *)expirationDateFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:kCouchbaseDateFormat];
    }
    
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

- (void)setupWithSyncUrl:(NSURL *)syncUrl
                username:(NSString *)username
{
    [self setupWithSyncUrl:syncUrl username:username cookieName:nil sessionID:nil expirationDate:nil];
}

- (void)setupWithSyncUrl:(NSURL *)syncUrl
                username:(NSString *)username
              cookieName:(NSString *)cookieName
               sessionID:(NSString *)sessionID
          expirationDate:(NSDate *)expirationDate
{
    if (self.couchbase) {
        [self logoutUser];
    }
    
    CookieAuthenticationSetup *weakSelf __weak = self;
    
    if (cookieName && sessionID && expirationDate) {
        //uses new credentials and stores them in NSHTTPCookieStorage
        self.authenticationProvider = [[YACouchbaseCookieAuthenticationProvider alloc] initWithCookieName:cookieName
                                                                                                sessionID:sessionID
                                                                                           expirationDate:expirationDate
                                                                                                      url:syncUrl];
    } else {
        //uses already stored credentials in NSHTTPCookieStorage
        self.authenticationProvider = [[YACouchbaseCookieAuthenticationProvider alloc] init];
    }
    
    self.authenticationProvider.UnauthorizedHandler = ^{
        [weakSelf logoutUser];
    };
    
    NSError *error = nil;
    
    self.couchbase = [[YACouchbase alloc] init];
    [self.couchbase openDatabaseWithName:username syncURL:syncUrl authenticatorProvider:self.authenticationProvider error:error];
    if (error) {
        exit(-1);
    }
    
    [self.couchbase.couchbaseNotificationCenter addReplicationObserver:self];
    
    [self.couchbase startReplication];
}

- (void)logoutUser
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
