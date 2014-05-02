//
//  SyncGatewayUserInfo.m
//  cblmodelgenerator
//

#import "SyncGatewayUserInfo.h"

@implementation SyncGatewayUserInfo

- (void)setAdmin_channels:(NSArray*)admin_channels {
	_admin_channels = admin_channels;
	[self modified];
	[self propagateParentTo:admin_channels];
}

- (void)setDisabled:(bool)disabled {
	_disabled = disabled;
	[self modified];
}

@end