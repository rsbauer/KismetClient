//
//  MapViewController.h
//  KismetClient
//
//  Created by Robert Bauer on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"
#import <MapKit/MapKit.h>
#import "REVClusterMapView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
//    IBOutlet MKMapView *mapView;
    REVClusterMapView *mapView;
}


@end
