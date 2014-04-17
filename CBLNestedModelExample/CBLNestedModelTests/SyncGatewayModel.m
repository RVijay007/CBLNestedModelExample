//
//  SyncGatewayModel.m
//  cblmodelgenerator
//

#import "SyncGatewayModel.h"

@implementation SyncGatewayModel
@dynamic adminInterface;
@dynamic interface;
@dynamic log;
@dynamic databases;

+ (Class)databasesItemClass {
	return [SyncGatewayDatabase class];
}

@end