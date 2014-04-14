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
    
    [self jsonEncodingTest];
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

@end
