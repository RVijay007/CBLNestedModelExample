//
//  SyncGatewayDatabase.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "SyncGatewayUserInfo.h"

@interface SyncGatewayDatabase : CBLNestedModel
@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* server;
@property (nonatomic, copy) NSString* sync;
@property (nonatomic, strong) NSDictionary* users;

@end