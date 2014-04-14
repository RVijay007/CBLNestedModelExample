//
//  NSObject+Properties.h
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/11/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Properties)

- (NSDictionary*)allProperties;     // PropertyName --> [Attributes]

/**
 * Converts a property attribute to the class it refers to
 * Primitives map to NSNumber
 */
+ (Class)classForPropertyTypeAttribute:(NSString*)propertyTypeAttribute;

@end
