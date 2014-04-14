//
//  AppDelegate.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/13/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "AppDelegate.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import "MyCBLModel.h"
#import "MyCBLChildModel.h"
#import "SyncGatewayModel.h"

typedef void(^PrintError)(NSError*, NSString*);

@interface AppDelegate ()
@property (weak, nonatomic) CBLDatabase* database;
@property (copy, nonatomic) PrintError printError;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.printError = ^(NSError* error, NSString* msg) {
        if(error) {
            NSLog(@"Error %@: %@", msg, error);
        }
    };
    
    // [self jsonEncodingTest];
    [self nestedModelTest];
}

/**
 * This test shows that changes to child models do not get saved to the parent CBLModel when they are initially created
 */
- (void)jsonEncodingTest {
    // Create Database
    NSError* error;
    CBLDatabase* database = [[CBLManager sharedInstance] databaseNamed:@"jsonencodingtest" error:&error];
    if(!database) {
        NSAssert(NO, @"Error creating db: %@", error);
    }
    
    [database.modelFactory registerClass:[MyCBLModel class] forDocumentType:@"MyCBLModel"];
    
    // Creates a model and creates a relationship to another model
    MyCBLModel* parentModel = [[MyCBLModel alloc] initWithNewDocumentInDatabase:database];
    parentModel.string = @"Parent Model";
    [parentModel save:&error];
    self.printError(error, @"saving parent model");
    
    MyCBLModel* anotherModel = [[MyCBLModel alloc] initWithNewDocumentInDatabase:database];
    anotherModel.string = @"Another Model";
    [anotherModel save:&error];
    self.printError(error, @"saving another model");
    
    parentModel.model = anotherModel;
    [parentModel save:&error];
    self.printError(error, @"saving after setting another model as relationship to parent");
    
    /**
     * Test 1: Create a child model, assign it to the parent model, save, and then make changes to the child model
     * with the same object. See if the name changes in the database on the second save.
     * 
     * This test FAILS.
     */
    MyCBLChildModel* childModel = [[MyCBLChildModel alloc] init];
    parentModel.firstChild = childModel;
    [parentModel save:&error];
    
    childModel.name = @"John Doe";              // Continue to use the same pointer as we first created
    childModel.onMutate();
    [parentModel save:&error];
    
    /**
     * Test 2: Create a child model, assign it to the parent model, save, and then make changes to the child model
     * with the same object. See if the name changes in the database on the second save.
     *
     * This test SUCCEEDS!
     */
    childModel = [[MyCBLChildModel alloc] init];
    parentModel.secondChild = childModel;
    [parentModel save:&error];
    
    childModel = parentModel.secondChild;       // Refresh the ptr to the parent's child
    childModel.name = @"Jane Doe";
    childModel.onMutate();
    [parentModel save:&error];
}

- (void)nestedModelTest {
    // Create Database
    NSError* error;
    CBLDatabase* database = [[CBLManager sharedInstance] databaseNamed:@"nestedmodeltest" error:&error];
    if(!database) {
        NSAssert(NO, @"Error creating db: %@", error);
    }
    
    // Create a sync gateway model
    SyncGatewayModel* syncGateway = [[SyncGatewayModel alloc] initWithNewDocumentInDatabase:database];
    syncGateway.interface = @":4984";
    syncGateway.adminInterface = @"127.0.0.1:4985";
    syncGateway.log = @[@"CRUD", @"CRUD+", @"HTTP", @"HTTP+", @"Access", @"Cache", @"Shadow", @"Shadow+", @"Changes", @"Changes+"];
    [syncGateway save:&error];
    self.printError(error, @"saving basic sync gateway");
    
    // Create database
    SyncGatewayDatabase* syncDatabase = [[SyncGatewayDatabase alloc] init];
    syncGateway.databases = @{@"my-sync-db" : syncDatabase};
    
    syncDatabase.server = @"http://localhost:8091";
    syncDatabase.bucket = @"my-remote-bucket";
    syncDatabase.sync = @"function(doc) {channel(doc.channels);}";
    [syncGateway save:&error];
    self.printError(error, @"saving db info to sync gateway");
    
    // Add user info
    SyncGatewayUserInfo* userInfo = [[SyncGatewayUserInfo alloc] init];
    userInfo.disabled = true;
    userInfo.admin_channels = @[@"public"];
    
    NSDictionary* databases = syncGateway.databases;
    syncDatabase = databases[@"my-sync-db"];    // We must get the database again because the save invalidated the old database
    syncDatabase.users = @{@"GUEST" : userInfo};
    [userInfo setParent:syncDatabase];                      // UserInfo can now mutate and notify parent CBLModel
    [syncDatabase modified];                                // We changed syncDatabase
    [syncGateway save:&error];
    self.printError(error, @"saving userinfo to sync gateway");
    
    // Change user info to illustrate propagation of modification
    
    userInfo = [syncGateway.databases[@"my-sync-db"] users][@"GUEST"];
    userInfo.disabled = false;                              // Changed userInfo as an example
    [userInfo modified];                                    // We can just call modified on userInfo and it will notify the proper CBLModel
    [syncGateway save:&error];
    self.printError(error, @"saving modified userinfo to sync gateway");
}

@end
