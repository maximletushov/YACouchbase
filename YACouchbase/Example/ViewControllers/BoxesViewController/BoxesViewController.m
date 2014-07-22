//
//  BoxesViewController.m
//  YACouchbase
//
//  Created by Maxim on 7/17/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "BoxesViewController.h"
#import "Box.h"
#import "ChangeBoxViewController.h"

@interface BoxesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CBLLiveQuery *liveQuery;

@end

@implementation BoxesViewController

- (void)dealloc
{
    [self.liveQuery removeObserver:self forKeyPath:@"rows" context:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeQuery];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIBarButtonItem *createNewBoxButton = [[UIBarButtonItem alloc] initWithTitle:@"New Box"
                                                                           style:(UIBarButtonItemStylePlain)
                                                                          target:self
                                                                          action:@selector(createNewBox:)];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                                                     style:(UIBarButtonItemStylePlain)
                                                                    target:self
                                                                    action:@selector(logout:)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = createNewBoxButton;
}

#pragma mark -

- (void)initializeQuery
{
    CBLQuery* query = [[self.setup.couchbase.database viewNamed: @"boxes"] createQuery];
    self.liveQuery = query.asLiveQuery;
    [self.liveQuery addObserver:self forKeyPath:@"rows"
                        options:0
                        context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.liveQuery) {
        [self.tableView reloadData];
    }
}

- (Box *)boxForIndex:(NSUInteger)index
{
    CBLQueryRow *row = [self.liveQuery.rows rowAtIndex:index];
    Box *box = [Box modelForDocument:row.document];
    return box;
}

#pragma mark -

- (IBAction)logout:(id)sender
{
    if (self.UserDidLogout) {
        self.UserDidLogout();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createNewBox:(id)sender
{
    [self performSegueWithIdentifier:@"createNewBox" sender:nil];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.liveQuery.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Box *box = [self boxForIndex:indexPath.row];
    
    cell.textLabel.text = box.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"editBox" sender:nil];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChangeBoxViewController *vc = segue.destinationViewController;
    
    vc.setup = self.setup;
    
    if ([segue.identifier isEqual:@"createNewBox"]) {
        
    } else if ([segue.identifier isEqual:@"editBox"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        vc.box = [self boxForIndex:indexPath.row];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
