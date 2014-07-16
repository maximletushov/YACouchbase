//
//  YACouchbaseDefines.h
//  YACouchbase
//
//  Created by Maxim on 7/11/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const struct YACouchbaseHTTPResponseCode {
    NSUInteger unauthorized_401;
    NSUInteger forbidden_403;
    NSUInteger internalServerError_500;
} YACouchbaseHTTPResponseCode;

extern const struct YACouchbaseHTTPGeneralHeader {
    __unsafe_unretained NSString *contentType;
} YACouchbaseHTTPGeneralHeader;

extern const struct YACouchbaseHTTPRequestHeader {
    __unsafe_unretained NSString *authorization;
    __unsafe_unretained NSString *cookie;
} YACouchbaseHTTPRequestHeader;

extern const struct YACouchbaseHTTPResponseHeader {
    __unsafe_unretained NSString *setCookie;
} YACouchbaseHTTPResponseHeader;
