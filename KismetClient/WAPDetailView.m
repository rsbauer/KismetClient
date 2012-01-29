//
//  WAPDetailView.m
//  KismetClient
//
//  Created by Robert Bauer on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WAPDetailView.h"
#import "objc/runtime.h"
#import "KismetClientAppDelegate.h"
#import "APType.h"
#import "APWep.h"
#import "REVClusterPin.h"

#define IGNORE_TAG 99999

@implementation WAPDetailView

@synthesize accessPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [accessPoint release];
    
    [mapView release];
    [table release];
    
//    [bssidLabel release];
//    [ssidLabel release];
//    [addedOnLabel release];
//    [channelLabel release];
//    [lastSeenLabel release];
//    [typeLabel release];
//    [webLabel release];
//    [rangeipLabel release];
//    [maxrateLabel release];
//    
//    [maxaltLabel release];
//    [maxlatLabel release];
//    [maxlonLabel release];
//    [maxspdLabel release];
//    
//    [minaltLabel release];
//    [minlatLabel release];
//    [minlonLabel release];
//    [minspdLabel release];
     
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(accessPoint == nil)
        return;
    
//    scrollView.contentSize = subView.bounds.size;
//    [scrollView addSubview:subView];
    
//    table = (UITableView *)[self.view viewWithTag:1];
    table.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    //  NSDecimal *avglat = (accessPoint.minlat + accessPoint.maxlat) / 2;
    NSDecimalNumber *divisor = [[NSDecimalNumber alloc] initWithInteger:2];
    NSDecimalNumber *avglat = [[accessPoint.minlat decimalNumberByAdding:accessPoint.maxlat] decimalNumberByDividingBy:divisor];
    NSDecimalNumber *avglon = [[accessPoint.minlon decimalNumberByAdding:accessPoint.maxlon] decimalNumberByDividingBy:divisor];
    
            
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([accessPoint.minlat doubleValue], [accessPoint.minlon doubleValue]);
    point.title = @"MIN";
//    [mapView addAnnotation:point];

    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = CLLocationCoordinate2DMake([accessPoint.maxlat doubleValue], [accessPoint.maxlon doubleValue]);
    point2.title = @"MAX";
//    [mapView addAnnotation:point2];

    /*
    MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
    point3.coordinate = CLLocationCoordinate2DMake([avglat doubleValue], [avglon doubleValue]);
    point3.title = accessPoint.bssid;    
    [mapView addAnnotation:point3];
    */
    REVClusterPin *point3 = [[REVClusterPin alloc] init];
    point3.coordinate = CLLocationCoordinate2DMake([avglat doubleValue], [avglon doubleValue]);
    point3.title = accessPoint.bssid;
    point3.wep = [accessPoint.wep intValue];
    [mapView addAnnotation:point3];
    
    CLLocationCoordinate2D pointACoordinate = [point coordinate];
    CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:pointACoordinate.latitude longitude:pointACoordinate.longitude];
    CLLocationCoordinate2D pointBCoordinate = [point2 coordinate];
    CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:pointBCoordinate.latitude longitude:pointBCoordinate.longitude];
    
    
    CLLocation *firstLocation = [[[CLLocation alloc] initWithLatitude:[avglat doubleValue] longitude:[avglon doubleValue]] autorelease];
    CLLocation *secondLocation = [[[CLLocation alloc] initWithLatitude:[accessPoint.maxlat doubleValue] longitude:[accessPoint.maxlon doubleValue]] autorelease];
    CLLocationDistance distance = [secondLocation distanceFromLocation:firstLocation];
    
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:point3.coordinate radius:distance]];

    MKCoordinateRegion mapReg = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([avglat doubleValue], [avglon doubleValue]), distance * 3, distance * 3);
    
    [mapView setRegion:mapReg];
    

    [point3 release];
    [point2 release];
    [point release];
    
    [pointALocation release];
    [pointBLocation release];
    [divisor release];

}

- (MKAnnotationView *)mapView:(MKMapView *)localMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    static NSString *SFAnnotationIdentifierGreen = @"SFAnnotationIdentifierGreen";
    static NSString *SFAnnotationIdentifierRed = @"SFAnnotationIdentifierRed";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[localMapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifierRed];

    if ([[APWep getWepName:pin.wep] isEqualToString:@"NONE"]) {
        pinView = (MKPinAnnotationView *)[localMapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifierGreen];
    }

    if (!pinView)
    {
        MKAnnotationView *annotationView = nil;
        UIImage *flagImage = nil;
        
        if ([[APWep getWepName:pin.wep] isEqualToString:@"NONE"]) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SFAnnotationIdentifierGreen] autorelease];
            flagImage = [UIImage imageNamed:@"pin-green"];
        }
        else {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SFAnnotationIdentifierRed] autorelease];
            flagImage = [UIImage imageNamed:@"pin-red"];
        }
        
        annotationView.image = flagImage;
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }

    return pinView;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
    circleView.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.25];;
    return [circleView autorelease];

}

//- (MKOverlayView *)viewForOverlay:(id<MKOverlay>)overlay
//{
//    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
//    circleView.fillColor = [UIColor blueColor];
//    return [circleView autorelease];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - table datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count;
    
    objc_property_t *properties = class_copyPropertyList([AccessPoint class], &count);
    free(properties);
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *configCellId = @"cell";
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:configCellId];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:configCellId] autorelease];
        [cell setAutoresizesSubviews:YES];
    }
    
    NSUInteger count;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"h:mm:ssa"];

    objc_property_t *properties = class_copyPropertyList([AccessPoint class], &count);
    objc_property_t property = properties[[indexPath row]];
    const char *propName = property_getName(property);
    NSString *propNameString = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
    
    if(propName && [indexPath row] > 0)
    {
        if(![propNameString isEqualToString:@"ignore"])
        {
            id value = [accessPoint valueForKey:propNameString];

            cell.textLabel.text = propNameString;
            
            if([propNameString isEqualToString:@"addedOn"] || [propNameString isEqualToString:@"lastSeen"])
            {
                cell.detailTextLabel.text = [dateFormatter stringFromDate:value];
            }
            else
            {
                if([propNameString isEqualToString:@"type"])
                {
                    int num = [[NSString stringWithFormat:@"%@", value] intValue];
                    value = [APType getTypeName:num];
                }

                if([propNameString isEqualToString:@"wep"])
                {
                    int num = [[NSString stringWithFormat:@"%@", value] intValue];
                    value = [APWep getWepName:num];
                }
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", value];
            }
            
            cell.accessoryView = nil;
        }
        else
        {
            // setup switch
            cell.textLabel.text = @"Ignore";
            cell.detailTextLabel.text = @"";
            UISwitch *ignoreSwitch = [[[UISwitch alloc] init] autorelease];
            ignoreSwitch.tag = IGNORE_TAG;
                        
            if([accessPoint.ignore isEqualToNumber:[NSNumber numberWithInt:1]])
                [ignoreSwitch setOn:YES];
            else
                [ignoreSwitch setOn:NO];
            
            [ignoreSwitch addTarget:self action:@selector(ignoreSwitchToggle:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = ignoreSwitch;
        }
    }
    else
    {
        cell.textLabel.text = @"Properties";
        cell.detailTextLabel.text = @"";
        cell.accessoryView = nil;
    }

    /*
    NSMutableString *propPrint = [NSMutableString string];
    for(int a = 0; a < count; a++)
    {        
        objc_property_t property = properties[a];
        
        const char *propName = property_getName(property);
        NSString *propNameString = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            id value = [instance valueForKey:propNameString];
            
            if([value isKindOfClass:[NSArray class]])
            {
                [propPrint appendString:[DumpClass dumpArray:value propName:propNameString]];
            }
            else {
                [propPrint appendString:[NSString stringWithFormat:@"%@=%@\n", propNameString, value]];
            }
            
        }
        
    }
     */
    
    free(properties);
    
    
    
    return cell;
}

// table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)ignoreSwitchToggle:(id)sender
{
    UISwitch *ignoreSwitch = (UISwitch *)sender;

    NSError *error;
    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    /*

    // Retrieve the entity from the local store -- much like a table in a database
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessPoint" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Set the predicate -- much like a WHERE statement in a SQL database
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ssid == %@ and bssid == %@ and self in %@", accessPoint.ssid, accessPoint.bssid, [accessPoint ap_server]];
    [request setPredicate:predicate];
    
    // Set the sorting -- mandatory, even if you're fetching a single record/object
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"addedOn" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release]; sortDescriptors = nil;
    [sortDescriptor release]; sortDescriptor = nil;
    
    // Request the data -- NOTE, this assumes only one match, that 
    // yourIdentifyingQualifier is unique. It just grabs the first object in the array. 
    NSArray *records = [context executeFetchRequest:request error:&error];
    [request release];
    
    if([records count] > 0)
    {
        AccessPoint *existingAP = (AccessPoint *)[records objectAtIndex:0];

        NSLog(@"Ignore 1: %@", existingAP.ignore);
        if(ignoreSwitch.isOn)
            existingAP.ignore = [NSNumber numberWithInt:1];
        else
            existingAP.ignore = [NSNumber numberWithInt:0];
        
        accessPoint.ignore = existingAP.ignore;
        NSLog(@"Ignore 2: %@", existingAP.ignore);

        if(![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
            exit(-1);  // Fail
        }
    }

    */

    
    if(ignoreSwitch.isOn)
        accessPoint.ignore = [NSNumber numberWithInt:1];
    else
        accessPoint.ignore = [NSNumber numberWithInt:0];

    if(![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        exit(-1);  // Fail
    }
}
@end
