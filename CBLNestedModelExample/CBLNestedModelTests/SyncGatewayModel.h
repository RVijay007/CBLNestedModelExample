//
//  SyncGatewayModel.h
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/14/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface SyncGatewayModel : CBLModel

@property (copy, nonatomic) NSString* interface;
@property (copy, nonatomic) NSString* adminInterface;
@property (copy, nonatomic) NSArray* log;
@property (strong, nonatomic) NSDictionary* databases;

@end

@interface SyncGatewayDatabase : CBLNestedModel

@property (copy, nonatomic) NSString* server;
@property (copy, nonatomic) NSString* bucket;
@property (copy, nonatomic) NSString* sync;
@property (strong, nonatomic) NSDictionary* users;

@end

@interface SyncGatewayUserInfo : CBLNestedModel

@property (assign, nonatomic) bool disabled;
@property (strong, nonatomic) NSArray* admin_channels;

@end