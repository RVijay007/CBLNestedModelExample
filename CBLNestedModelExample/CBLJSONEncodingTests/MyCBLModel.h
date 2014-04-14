//
//  MyCBLModel.h
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/12/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "MyCBLChildModel.h"

@interface MyCBLModel : CBLModel

// JSON-compatible
@property (assign, nonatomic) int intValue;
@property (assign, nonatomic) float floatValue;
@property (assign, nonatomic) double doubleValue;
@property (assign, nonatomic) bool boolValue;
@property (assign, nonatomic) NSInteger integerValue;
@property (assign, nonatomic) NSUInteger uintegerValue;
@property (copy, nonatomic) NSString* string;
@property (strong, nonatomic) NSNumber* number;
@property (strong, nonatomic) NSNull* null;

// Non-JSON compatible, using converters
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSData* data;
@property (strong, nonatomic) NSDecimalNumber* decimal;

// Collection classes
@property (strong, nonatomic) NSArray* models;
@property (strong, nonatomic) NSArray* childModels;

// Objects
@property (weak, nonatomic) CBLModel* model;
@property (strong, nonatomic) MyCBLChildModel* firstChild;
@property (strong, nonatomic) MyCBLChildModel* secondChild;

@end
