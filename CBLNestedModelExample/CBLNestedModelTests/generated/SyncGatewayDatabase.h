//
//  SyncGatewayDatabase.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "SyncGatewayUserInfo.h"

@interface SyncGatewayDatabase : CBLNestedModel
@property (nonatomic, strong) NSString* bucket;
@property (nonatomic, strong) NSString* server;
@property (nonatomic, strong) NSString* sync;
@property (nonatomic, strong) NSDictionary* users;

@end