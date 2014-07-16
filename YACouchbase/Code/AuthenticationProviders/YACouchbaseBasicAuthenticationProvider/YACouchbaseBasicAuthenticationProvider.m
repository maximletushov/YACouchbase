//
//  YACouchbaseBaseAuthenticationProvider.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseBasicAuthenticationProvider.h"
#import <CouchbaseLite/CBLAuthenticator.h>
#import "YACouchbaseDefines.h"


@interface YACouchbaseBasicAuthenticationProvider ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end


@implementation YACouchbaseBasicAuthenticationProvider

- (instancetype)initWithName:(NSString *)name password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = name;
        self.password = password;
    }
    return self;
}

- (NSString *)authorizationHeaderValue
{
	NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    
    NSData *rawData = [basicAuthCredentials dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [rawData base64EncodedStringWithOptions:0];
    
    return [NSString stringWithFormat:@"Basic %@", base64String];
}

#pragma mark -
#pragma mark YACouchbaseAuthProvider

- (void)provideAuthenticationForReplication:(CBLReplication *)replication
{
    [self addHTTPRequestHeader:YACouchbaseHTTPRequestHeader.authorization
                     withValue:[self authorizationHeaderValue]
                 toReplication:replication];
}

@end
