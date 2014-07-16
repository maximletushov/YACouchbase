//
//  YACouchbaseDefines.m
//  YACouchbase
//
//  Created by Maxim on 7/11/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseDefines.h"

const struct YACouchbaseHTTPResponseCode YACouchbaseHTTPResponseCode = {
    .unauthorized_401 = 401,
    .forbidden_403 = 403,
    .internalServerError_500 = 500,
};

const struct YACouchbaseHTTPGeneralHeader YACouchbaseHTTPGeneralHeader = {
    .contentType = @"Content-Type",
};

const struct YACouchbaseHTTPRequestHeader YACouchbaseHTTPRequestHeader = {
    .authorization = @"Authorization",
    .cookie = @"Cookie",
};

const struct YACouchbaseHTTPResponseHeader YACouchbaseHTTPResponseHeader = {
    .setCookie = @"Set-Cookie",
};
