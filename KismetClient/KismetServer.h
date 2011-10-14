//
//  KismetServer.h
//  KismetClient
//
//  Created by Robert Bauer on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccessPoint;

@interface KismetServer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * orderingValue;
@property (nonatomic, retain) NSString * port;
@property (nonatomic, retain) NSString * serverName;
@property (nonatomic, retain) NSSet *server_ap;
@end

@interface KismetServer (CoreDataGeneratedAccessors)

- (void)addServer_apObject:(AccessPoint *)value;
- (void)removeServer_apObject:(AccessPoint *)value;
- (void)addServer_ap:(NSSet *)values;
- (void)removeServer_ap:(NSSet *)values;
@end
