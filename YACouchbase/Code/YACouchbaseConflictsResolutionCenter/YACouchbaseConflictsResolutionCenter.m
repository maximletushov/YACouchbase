//
//  YACouchbaseConflictsResolutionCenter.m
//  YACouchbase
//
//  Created by Maxim on 7/9/14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YACouchbaseConflictsResolutionCenter.h"

static NSString *const kChanges = @"changes";
static NSString *const kType = @"type";


@interface YACouchbaseConflictsResolutionCenter ()

@property (nonatomic, weak) CBLDatabase *database;
@property (nonatomic, strong) NSMutableDictionary *solvers;

@end


@implementation YACouchbaseConflictsResolutionCenter

- (instancetype)initWithDatabase:(CBLDatabase *)database
{
    NSAssert(database, @"Database should not be nil");
    
    self = [super init];
    if (self) {
        self.database = database;
        
        [self startObservDatabase];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservDatabase];
}

- (NSMutableDictionary *)solvers
{
    if (!_solvers) {
        _solvers = [NSMutableDictionary new];
    }
    return _solvers;
}

- (void)registerConflictsSolver:(id<YACouchbaseConflictsSolver>)solver forDocumentType:(NSString*)type
{
    if (!solver) {
        return ;
    }
    
    if (!type) {
        return ;
    }
    
    self.solvers[type] = solver;
}

- (id<YACouchbaseConflictsSolver>)conflictsSolverForDocumentType:(NSString *)type
{
    if (!type) {
        return nil;
    }
    return self.solvers[type];
}

#pragma mark -
#pragma mark No

- (void)startObservDatabase
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(databaseDidChangeNotification:)
                                                 name:kCBLDatabaseChangeNotification
                                               object:self.database];
}

- (void)stopObservDatabase
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)databaseDidChangeNotification:(NSNotification *)notification
{
    NSArray* changes = notification.userInfo[kChanges];
    for (CBLDatabaseChange *change in changes) {
        if (change.inConflict) {
            CBLDocument *document = [self.database existingDocumentWithID:change.documentID];
            if (document) {
                NSString *type = document.properties[kType];
                if (type) {
                    id<YACouchbaseConflictsSolver>solver = self.solvers[type];
                    
                    if ([solver respondsToSelector:@selector(solveConflictsWithDatabaseChange:)]) {
                        [solver solveConflictsWithDatabaseChange:change];
                    }
                }
            }
        }
    }
}

@end
