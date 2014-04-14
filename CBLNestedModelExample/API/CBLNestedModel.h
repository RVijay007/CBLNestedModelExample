//
//  CBLNestedModel.h
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/11/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface CBLNestedModel : NSObject

- (id)initFromJSON:(id)jsonObject;
- (id)encodeToJSON;

- (void)reparent:(CBLNestedModel*)parent;

@end

@interface CBLNestedModel (CBLModel)

- (void)setOnMutate:(CBLOnMutateBlock)onMutate;

@end

