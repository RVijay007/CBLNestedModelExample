//
//  NSObject+Properties.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/11/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "NSObject+Properties.h"
#import<objc/runtime.h>

@implementation NSObject (Properties)

- (NSDictionary*)allProperties {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    for (unsigned i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSMutableArray* propertyAttr = [[[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","] mutableCopy];

        dictionary[propertyName] = propertyAttr;
    }
    
    free(properties);
    
    return dictionary;
}

+ (Class)classForPropertyTypeAttribute:(NSString*)propertyTypeAttribute {
    Class typeClass = nil;
    
    if([propertyTypeAttribute hasPrefix:@"T@"] && [propertyTypeAttribute length] > 2) {
        NSString* typeClassName = [propertyTypeAttribute substringWithRange:NSMakeRange(3, [propertyTypeAttribute length]-4)];
        typeClass = NSClassFromString(typeClassName);
        if(!typeClass) {
            NSLog(@"Warning: PropertyTypeAttrbute did not match to a valid class: %@-->%@", propertyTypeAttribute, typeClassName);
        }
    } else if(![propertyTypeAttribute hasPrefix:@"T@"] && [propertyTypeAttribute length] == 2) {
        // This is a primitive object
        typeClass = [NSNumber class];
    }
    
    return typeClass;
}

@end
