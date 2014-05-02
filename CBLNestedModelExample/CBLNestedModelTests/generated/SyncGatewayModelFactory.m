//
//  SyncGatewayModelFactory.m
//  cblmodelgenerator
//

#import "SyncGatewayModelFactory.h"
#import "SyncGatewayModel.h"

@implementation SyncGatewayModelFactory

+ (void)registerModelWithCBLModelFactory {
	[[CBLModelFactory sharedInstance] registerClass:[SyncGatewayModel class] forDocumentType:NSStringFromClass([SyncGatewayModel class])];
}

@end