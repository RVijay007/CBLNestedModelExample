//
//  SyncGatewayModel.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "SyncGatewayDatabase.h"

@interface SyncGatewayModel : CBLModel
@property (nonatomic, strong) NSString* adminInterface;
@property (nonatomic, strong) NSString* interface;
@property (nonatomic, strong) NSArray* log;
@property (nonatomic, strong) NSDictionary* databases;

@end