//
//  GPSTrack.h
//  KismetClient
//
//  Created by Robert Bauer on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GPSTrack : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDecimalNumber * alt;
@property (nonatomic, retain) NSNumber * fix;
@property (nonatomic, retain) NSDecimalNumber * heading;
@property (nonatomic, retain) NSDecimalNumber * lat;
@property (nonatomic, retain) NSDecimalNumber * lon;
@property (nonatomic, retain) NSDecimalNumber * speed;

@end
