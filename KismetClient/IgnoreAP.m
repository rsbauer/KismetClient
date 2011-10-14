//
//  IgnoreNetwork.m
//  KismetClient
//
//  Created by Robert Bauer on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IgnoreAP.h"
#import "KismetClientAppDelegate.h"
#import "AccessPoint.h"


@implementation IgnoreAP

@synthesize aps;

- (id)init
{
    self = [super init];
    if (self) {

        if(aps == nil)
        {
            aps = [[NSMutableArray alloc] init];    
        }
        else
        {
            [aps release];
            aps = nil;
            aps = [[NSMutableArray alloc] init];
        }
        
        // managed object context is where all the operations are happening
        NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
        // holder for the data
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessPoint" inManagedObjectContext:context];
        
        // fetch request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        // Set the predicate -- much like a WHERE statement in a SQL database
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ignore == 1"];
        [fetchRequest setPredicate:predicate];
        
        // set sorting
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastSeen" ascending:NO];
        // sort info needs to be in an array
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        // perform fetch
        [fetchRequest setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
        
        NSError *err = nil;
        NSArray *searchResults = [context executeFetchRequest:fetchRequest error:&err];
        [fetchRequest autorelease];
        
        if(err)
        {
            NSLog(@"%@", err);
        }
        else
        {
            // check if we have data
            if([searchResults count] > 0)
            {
                for(AccessPoint *ap in searchResults)
                {
                    [self.aps addObject:[NSString stringWithFormat:@"%@%@", ap.ssid, ap.bssid]];
                }
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.aps = nil;
    
    [super dealloc];
}

@end
