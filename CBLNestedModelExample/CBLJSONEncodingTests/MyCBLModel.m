//
//  MyCBLModel.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/12/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "MyCBLModel.h"

@implementation MyCBLModel
@dynamic integerValue, intValue, floatValue, doubleValue, boolValue, uintegerValue, string, date, number, null, data, decimal, models, childModels, model, firstChild, secondChild;

- (instancetype)initWithNewDocumentInDatabase:(CBLDatabase*)database {
    self = [super initWithNewDocumentInDatabase:database];
    if(self) {
        self.intValue = -1;
        self.integerValue = -10;
        self.floatValue = 3.14;
        self.doubleValue = sqrt(2);
        self.boolValue = true;
        self.uintegerValue = 20;
        self.string = @"MyNestedModelA";
        self.date = [NSDate date];
        self.number = [NSNumber numberWithLong:-10000];
        self.null = [NSNull null];
        self.data = [NSData data];
        self.decimal = [NSDecimalNumber decimalNumberWithMantissa:514 exponent:10000 isNegative:YES];
        
        self.models = @[];
        self.models = nil;
        self.childModels = @[];
        
        self.model = nil;
        self.firstChild = nil;
        self.secondChild = nil;
    }
    
    return self;
}

+ (Class)modelsItemClass {
    return [MyCBLModel class];
}

//+ (Class)childModelsItemClass {
//    return [MyCBLChildModel class];
//}

@end
