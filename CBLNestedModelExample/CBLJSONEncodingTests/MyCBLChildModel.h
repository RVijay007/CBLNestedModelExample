//
//  MyCBLChildModel.h
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/12/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface MyCBLChildModel : NSObject <CBLJSONEncoding>

@property (copy, nonatomic) CBLOnMutateBlock onMutate;
@property (copy, nonatomic) NSString* name;

- (id)initWithJSON:(id)jsonObject;
- (id)encodeAsJSON;

- (void)setOnMutate:(CBLOnMutateBlock)onMutate;

@end
