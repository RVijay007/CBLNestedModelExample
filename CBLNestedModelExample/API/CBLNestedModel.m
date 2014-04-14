//
//  CBLNestedModel.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/11/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "CBLNestedModel.h"
#import "NSObject+Properties.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CBLNestedModelModification : NSObject
@property (copy, nonatomic) CBLOnMutateBlock onMutateBlock;

- (void)modified;
@end

@implementation CBLNestedModelModification

- (id)init {
    self = [super init];
    if(self) {
        self.onMutateBlock = nil;
    }
    
    return self;
}

- (void)modified {
    if(self.onMutateBlock)
        self.onMutateBlock();
}

@end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CBLNestedModel ()
@property (strong, nonatomic) CBLNestedModelModification* modObject;

- (id)convertValueFromJSON:(id)jsonObject toDesiredClass:(Class)desiredPropertyClass representedByPropertyName:(NSString*)propertyName;
+ (id)convertValueToJSON:(id)value;

@end

@implementation CBLNestedModel

- (id)init {
    self = [super init];
    if(self) {
        self.modObject = [[CBLNestedModelModification alloc] init];
    }
    
    return self;
}

#pragma mark - Decoding Methods (JSON --> class)

- (id)initFromJSON:(id)jsonObject {
    self = [self init];        // Default initilization
    if(self) {
        if([jsonObject isKindOfClass:[NSDictionary class]]) {
            // It must be a dictionary to represent a class
            
            NSDictionary* properties = [self allProperties];
            [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString* propertyName = key;
                NSArray* propertyAttr = obj;
                Class desiredPropertyClass = [NSObject classForPropertyTypeAttribute:propertyAttr[0]];
                
                id value = [self convertValueFromJSON:jsonObject[key] toDesiredClass:desiredPropertyClass representedByPropertyName:key];
                if(value) {
                    [self setValue:value forKey:propertyName];
                } else {
                    NSLog(@"No property name found that matches key: %@. Keeping default value.", propertyName);
                }
            }];
        }
    }
    
    return self;
}

- (id)convertValueFromJSON:(id)jsonObject toDesiredClass:(Class)desiredPropertyClass representedByPropertyName:(NSString*)propertyName {
    if(!jsonObject)
        return nil;
    
    id value = nil;
    
    // Block used by collection JSON objects to determine what class to convert values to
    Class(^CollectionClassTypeBlock)(Class klass, NSString* propertyName) = ^Class(Class klass, NSString* propertyName) {
        if(!(klass == [NSArray class] || klass == [NSDictionary class])) {
            // Objects are not collection classes
            klass = [CBLModel itemClassForArrayProperty:propertyName];
            if(!klass) {
                // There is no designated class, default to NSString
                klass = [NSString class];
            }
        }
        
        return klass;
    };
    
    if(desiredPropertyClass == [NSNumber class] ||
       desiredPropertyClass == [NSNull class] ||
       desiredPropertyClass == [NSString class]) {
        // JSON compatible objects will be mapped directly to the class variables
        value = jsonObject;
    } else if(desiredPropertyClass == [NSDate class]) {
        value = [CBLJSON dateWithJSONObject:jsonObject];
    } else if(desiredPropertyClass == [NSData class]) {
        value = [CBLJSON dataWithBase64String:jsonObject];
    } else if(desiredPropertyClass == [NSDecimalNumber class]) {
        value = [NSDecimalNumber decimalNumberWithString:jsonObject];
    } else if([desiredPropertyClass isSubclassOfClass:[CBLModel class]]) {
        // We have a relationship where jsonObject is the documentId String
        
        // Search all databases to find the relevant document
        NSArray* databaseNames = [[CBLManager sharedInstance] allDatabaseNames];
        __block CBLDocument* document = nil;
        [databaseNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CBLDatabase* database = [[CBLManager sharedInstance] existingDatabaseNamed:obj error:nil];
            document = [database existingDocumentWithID:jsonObject];
            if(document)
                *stop = YES;
        }];
        
        if(document) {
            // We have a document, but it may be a specific subclass. Attempt to create the subclass.
            value = [[CBLModelFactory sharedInstance] modelForDocument:document];
            if(!value) {
                // The document's type property was not registered, so we need to instantiate directly from the desired property class
                value = [desiredPropertyClass modelForDocument:document];
            }
        }
    } else if([desiredPropertyClass isSubclassOfClass:[CBLNestedModel class]]) {
        // Recursively instantiate the desired property class with the jsonObject
        // Does not handle polymorphism
        // Propagate the modification Object so that changes to nested models can go to top level CBLModel
        
        value = [[desiredPropertyClass alloc] initFromJSON:jsonObject];
        [value setModObject:self.modObject];
        
    } else if(desiredPropertyClass == [NSArray class]) {
        NSArray* jsonArray = jsonObject;
        
        NSMutableArray* objectArray = [NSMutableArray arrayWithCapacity:[jsonArray count]];
        [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id collectionValue = [self convertValueFromJSON:obj toDesiredClass:CollectionClassTypeBlock([obj class], propertyName) representedByPropertyName:propertyName];
                
            if(collectionValue) {
               [objectArray addObject:collectionValue];
            }
        }];
        
        value = objectArray;
    } else if(desiredPropertyClass == [NSDictionary class]) {
        NSDictionary* jsonDictionary = jsonObject;
        
        NSMutableDictionary* objectDict = [NSMutableDictionary dictionaryWithCapacity:[jsonDictionary count]];
        [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id collectionValue = [self convertValueFromJSON:obj toDesiredClass:CollectionClassTypeBlock([obj class], propertyName) representedByPropertyName:propertyName];
            if(collectionValue) {
                objectDict[key] = collectionValue;
            }
        }];
        
        value = objectDict;
    } else {
        NSLog(@"Warning: Unknown type of value to decode in JSON. Desired property class %@.", desiredPropertyClass);
    }
    
    return value;
}

#pragma mark - Encoding Methods (class --> JSON)

- (id)encodeToJSON {
    NSMutableDictionary* classJSON = [NSMutableDictionary dictionary];
    
    // Get a list of existing properties
    NSDictionary* properties = [self allProperties];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [CBLNestedModel convertValueToJSON:[self valueForKey:key]];
        if(value) {
            // Do not store nil values
            classJSON[key] = value;
        }
    }];
    
    return [classJSON copy];
}

+ (id)convertValueToJSON:(id)value {
    if(!value)
        return nil;
    
    if([value isKindOfClass:[NSData class]]) {
        value = [CBLJSON base64StringWithData:value];
    } else if ([value isKindOfClass:[NSDate class]]) {
        value = [CBLJSON JSONObjectWithDate: value];
    } else if ([value isKindOfClass:[NSDecimalNumber class]]) {
        value = [value stringValue];
    } else if([value isKindOfClass:[NSString class]] ||
              [value isKindOfClass:[NSNull class]] ||
              [value isKindOfClass:[NSNumber class]]) {
        // JSON-compatible, non-collection objects
        // Must come after NSDecimalNumber since NSDecimalNumber inherits from NSNumber
        return value;
    } else if([value isKindOfClass:[CBLModel class]]) {
        value = [[value document] documentID];
    } else if([value isKindOfClass:[CBLNestedModel class]]) {
        value = [value encodeToJSON];
    } else if([value isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*) value;
        NSMutableArray* returnArray = [@[] mutableCopy];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [returnArray addObject:[CBLNestedModel convertValueToJSON:obj]];
        }];
        value = [returnArray copy];
    } else if([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)value;
        NSMutableDictionary* returnDict = [NSMutableDictionary dictionary];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // Key should be an NSString
            returnDict[key] = [CBLNestedModel convertValueToJSON:obj];
        }];
        value = [returnDict copy];
        
    } else {
        // Unknown type - log it
        NSLog(@"Warning: Unknown type of value to encode. Value class name is %@.", [value class]);
        value = nil;
    }
    
    return value;
}

- (void)reparent:(CBLNestedModel*)parent {
    if(!parent) {
        NSLog(@"Warning: CBLNestedModel parent should never be nil");
    } else {
        self.modObject = [parent modObject];
    }
}

@end

@implementation CBLNestedModel (CBLModel)

- (void)setOnMutate:(CBLOnMutateBlock)onMutate {
    self.modObject.onMutateBlock = onMutate;
}

@end


