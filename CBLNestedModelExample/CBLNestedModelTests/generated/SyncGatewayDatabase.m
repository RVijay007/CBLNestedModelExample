//
//  SyncGatewayDatabase.m
//  cblmodelgenerator
//

#import "SyncGatewayDatabase.h"

@implementation SyncGatewayDatabase

- (void)setBucket:(NSString*)bucket {
	_bucket = bucket;
	[self modified];
}

- (void)setServer:(NSString*)server {
	_server = server;
	[self modified];
}

- (void)setSync:(NSString*)sync {
	_sync = sync;
	[self modified];
}

+ (Class)usersItemClass {
	return [SyncGatewayUserInfo class];
}

- (void)setUsers:(NSDictionary*)users {
	_users = users;
	[self modified];
	[self propagateParentTo:users];
}

@end