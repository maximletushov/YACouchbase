//
//  BoxesViewController.h
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCouchbaseSetup.h"

@interface BoxesViewController : UIViewController

@property (nonatomic, strong) BaseCouchbaseSetup *setup;

@property (nonatomic, copy) void(^UserDidLogout)(void);

@end
