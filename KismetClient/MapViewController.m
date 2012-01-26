//
//  MapViewController.m
//  KismetClient
//
//  Created by Robert Bauer on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "KismetClientAppDelegate.h"
#import "AccessPoint.h"
#import "REVClusterPin.h"
#import "REVClusterAnnotationView.h"

@implementation MapViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    [mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate*)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    
    // holder for the data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessPoint" inManagedObjectContext:context];
    

//    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    CGRect viewBounds = [[UIScreen mainScreen] bounds];
    
    mapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    
    // fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
//    [fetchRequest setFetchLimit:1000];

    // set sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastSeen" ascending:NO];
    // sort info needs to be in an array
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    // perform fetch
    [fetchRequest setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    NSError *err = nil;
    NSArray *searchResults = [context executeFetchRequest:fetchRequest error:&err];
    [fetchRequest release];
    
    if(err)
    {
        NSLog(@"%@", err);
    }
    else
    {
        // check if we have data
        if([searchResults count] > 0)
        {
            double minlat = 999;
            double maxlat = -999;
            double minlon = 999;
            double maxlon = -999;
            NSMutableArray *pins = [NSMutableArray array];

            
            for(AccessPoint *ap in searchResults)
            {
                if([ap.minlat doubleValue] < minlat)
                    minlat = [ap.minlat doubleValue];
                if([ap.maxlat doubleValue] > maxlat)
                    maxlat = [ap.maxlat doubleValue];
                
                if([ap.minlon doubleValue] < minlon)
                    minlon = [ap.minlon doubleValue];
                if([ap.maxlon doubleValue] > maxlon)
                    maxlon = [ap.maxlon doubleValue];
                
/*                
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = CLLocationCoordinate2DMake([ap.minlat doubleValue], [ap.minlon doubleValue]);
                point.title = ap.ssid;
                NSLog(@"AP: %@", ap.ssid);
*/
                
                REVClusterPin *pin = [[REVClusterPin alloc] init];
                pin.title = ap.ssid;
                pin.subtitle = @"Subtitle";
                pin.coordinate = CLLocationCoordinate2DMake([ap.minlat doubleValue], [ap.minlon doubleValue]);
                [pins addObject:pin];
                [pin release]; 
                
//                point.subtitle = [dateFormatter stringFromDate:tempLoc.timestamp];
//                [mapView addAnnotation:pin];
//                [pin release];
            }
            
            [mapView addAnnotations:pins];

            CLLocation *firstLocation = [[[CLLocation alloc] initWithLatitude:minlat longitude:minlon] autorelease];
            CLLocation *secondLocation = [[[CLLocation alloc] initWithLatitude:maxlat longitude:maxlon] autorelease];
//            CLLocationDistance distance = [secondLocation distanceFromLocation:firstLocation];
            
//            MKCoordinateRegion mapReg = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(maxlat, maxlon), (distance / 2), (distance / 2));
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxlat + minlat) / 2, (maxlon + minlon) / 2);
            MKCoordinateSpan span = MKCoordinateSpanMake(maxlat - minlat, maxlon - minlon);
            MKCoordinateRegion mapReg = MKCoordinateRegionMake(center, span);
            
            [mapView setRegion:mapReg];
        }
        else
        {
            // no locations saved
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data" message:@"No locations have been added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Map View Goodies

- (MKAnnotationView *)mapView:(MKMapView *)localMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        annView = (REVClusterAnnotationView*)[localMapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)[[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(REVClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        annView.canShowCallout = YES;
    } else {
        annView = [localMapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
        
        annView.image = [UIImage imageNamed:@"pinpoint.png"];
        annView.canShowCallout = YES;   
    }
    return annView;
}



@end
