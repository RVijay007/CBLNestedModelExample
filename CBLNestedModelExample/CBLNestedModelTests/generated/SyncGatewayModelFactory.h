//
//  SyncGatewayModelFactory.h
//  cblmodelgenerator
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface SyncGatewayModelFactory : NSObject

+ (void)registerModelWithCBLModelFactory;

@end