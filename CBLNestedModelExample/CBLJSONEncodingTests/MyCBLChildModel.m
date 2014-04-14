//
//  MyCBLChildModel.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/12/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "MyCBLChildModel.h"

@implementation MyCBLChildModel

- (id)init {
    self = [super init];
    if(self) {
        self.name = @"John Doe";
    }
    
    return self;
}

- (id)initWithJSON:(id)jsonObject {
    self = [self init];
    if(self) {
        self.name = jsonObject[@"name"];
    }
    
    return self;
}

- (id)encodeAsJSON {
    return @{@"name" : self.name};
}

- (void)setName:(NSString *)name {
    _name = [name copy];
}

- (void)setOnMutate:(CBLOnMutateBlock)onMutate {
    NSLog(@"Setting on mutate block");
    _onMutate = onMutate;
}

@end
