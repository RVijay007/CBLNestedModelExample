//
//  SyncGatewayUserInfo.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface SyncGatewayUserInfo : CBLNestedModel
@property (nonatomic, strong) NSArray* admin_channels;
@property (nonatomic, assign) bool disabled;

@end