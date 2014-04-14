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
 * This test shows that changes to child models do not get saved to the parent cblmodel when they are initially created
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
    
    // Creates a child model
    MyCBLChildModel* childModel = [[MyCBLChildModel alloc] init];
    parentModel.childModel = childModel;
    [parentModel save:&error];
    
    // Changes data - check to see if it is saved
    // Doesn't work
    childModel.name = @"Jane Doe";
    if(childModel.onMutate)
        childModel.onMutate();
    [parentModel save:&error];
    
    parentModel.childModel.name = @"Jane Doe";
    if(parentModel.childModel.onMutate) {
        parentModel.childModel.onMutate();
    }
    [parentModel save:&error];
}

@end
