//
//  WAPDetailView.h
//  KismetClient
//
//  Created by Robert Bauer on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AccessPoint.h"

// @interface WAPDetailView : UITableViewController <UITableViewDelegate>
@interface WAPDetailView : UIViewController <UITableViewDelegate, MKMapViewDelegate>
{
    AccessPoint *accessPoint;

    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *table;
    
//    IBOutlet UIScrollView *scrollView;
//    IBOutlet UIView *subView;
    
//    IBOutlet UILabel *bssidLabel;
//    IBOutlet UILabel *ssidLabel;
//    IBOutlet UILabel *addedOnLabel;
//    IBOutlet UILabel *channelLabel;
//    IBOutlet UILabel *lastSeenLabel;
//    IBOutlet UILabel *typeLabel;
//    IBOutlet UILabel *webLabel;
//    IBOutlet UILabel *rangeipLabel;
//    IBOutlet UILabel *maxrateLabel;
//    
//    IBOutlet UILabel *maxaltLabel;
//    IBOutlet UILabel *maxlatLabel;
//    IBOutlet UILabel *maxlonLabel;
//    IBOutlet UILabel *maxspdLabel;
//
//    IBOutlet UILabel *minaltLabel;
//    IBOutlet UILabel *minlatLabel;
//    IBOutlet UILabel *minlonLabel;
//    IBOutlet UILabel *minspdLabel;
}

@property (nonatomic, retain) AccessPoint *accessPoint; 

- (void)ignoreSwitchToggle:(id)sender;

@end
