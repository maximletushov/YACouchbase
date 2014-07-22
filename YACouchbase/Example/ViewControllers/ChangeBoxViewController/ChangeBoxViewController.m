//
//  ChangeBoxViewController.m
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "ChangeBoxViewController.h"

@interface ChangeBoxViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation ChangeBoxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.box) {
        self.titleTextField.text = self.box.title;
    }
}

- (IBAction)saveBox:(id)sender
{
    if (!self.box) {
        CBLDocument *document = [self.setup.couchbase.database createDocument];
        self.box = [Box modelForDocument:document];
        self.box.type = @"box";
        self.box.channels = @[self.setup.couchbase.database.name];
    }
    
    self.box.title = self.titleTextField.text;

    
    NSError *error = nil;
    
    [self.box save:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
