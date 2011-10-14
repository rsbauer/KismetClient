//
//  AccessPoint.h
//  KismetClient
//
//  Created by Robert Bauer on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KismetServer;

@interface AccessPoint : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * addedOn;
@property (nonatomic, retain) NSString * bssid;
@property (nonatomic, retain) NSNumber * channel;
@property (nonatomic, retain) NSDate * lastSeen;
@property (nonatomic, retain) NSDecimalNumber * maxalt;
@property (nonatomic, retain) NSDecimalNumber * maxlat;
@property (nonatomic, retain) NSDecimalNumber * maxlon;
@property (nonatomic, retain) NSDecimalNumber * maxrate;
@property (nonatomic, retain) NSDecimalNumber * maxspd;
@property (nonatomic, retain) NSDecimalNumber * minalt;
@property (nonatomic, retain) NSDecimalNumber * minlat;
@property (nonatomic, retain) NSDecimalNumber * minlon;
@property (nonatomic, retain) NSDecimalNumber * minspd;
@property (nonatomic, retain) NSString * rangeip;
@property (nonatomic, retain) NSString * ssid;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * wep;
@property (nonatomic, retain) NSNumber * ignore;
@property (nonatomic, retain) NSSet *ap_server;
@end

@interface AccessPoint (CoreDataGeneratedAccessors)

- (void)addAp_serverObject:(KismetServer *)value;
- (void)removeAp_serverObject:(KismetServer *)value;
- (void)addAp_server:(NSSet *)values;
- (void)removeAp_server:(NSSet *)values;
@end
