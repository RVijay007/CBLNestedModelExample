//
//  SyncGatewayModel.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "SyncGatewayDatabase.h"

@interface SyncGatewayModel : CBLModel
@property (nonatomic, copy) NSString* adminInterface;
@property (nonatomic, copy) NSString* interface;
@property (nonatomic, strong) NSArray* log;
@property (nonatomic, strong) NSDictionary* databases;

@end