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

- (instancetype)initWithNewDocumentInDatabase:(CBLDatabase*)database {
	self = [super initWithNewDocumentInDatabase:database];
	if(self) {
		self.type = NSStringFromClass([self class]);
	}
	return self;
}

+ (Class)databasesItemClass {
	return [SyncGatewayDatabase class];
}

@end