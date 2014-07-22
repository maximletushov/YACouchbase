//
//  ChangeBoxViewController.h
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCouchbaseSetup.h"
#import "Box.h"

@interface ChangeBoxViewController : UIViewController

@property (nonatomic, strong) Box *box;
@property (nonatomic, strong) BaseCouchbaseSetup *setup;

@end
