//
//  SyncGatewayModel.m
//  CBLNestedModelExample
//
//  Created by Ragu Vijaykumar on 4/14/14.
//  Copyright (c) 2014 RVijay007. All rights reserved.
//

#import "SyncGatewayModel.h"

@implementation SyncGatewayModel
@dynamic interface, adminInterface, log, databases;

+ (Class)databasesItemClass {
    return [SyncGatewayDatabase class];
}

@end

@implementation SyncGatewayDatabase

+ (Class)usersItemClass {
    return [SyncGatewayUserInfo class];
}

@end

@implementation SyncGatewayUserInfo

@end