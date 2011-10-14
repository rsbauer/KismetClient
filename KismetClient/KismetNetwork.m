//
//  KismetNetwork.m
//  KismetClient
//
//  Created by Robert Bauer on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KismetNetwork.h"
#import "AccessPoint.h"
#import "KismetServer.h"
#import "KismetClientAppDelegate.h"

@implementation KismetNetwork

@synthesize capabilities;
@synthesize server;

- (id)init
{
    self = [super init];
    if (self) {
        self.capabilities = [[[NSArray alloc] initWithObjects:
                              @"bssid", 
                              @"rangeip",
                              @"wep",
                              @"type",
                              @"maxrate",
                              @"channel",
                              @"minalt",
                              @"minlon",
                              @"minlat",
                              @"minalt",
                              @"minspd",
                              @"maxlat",
                              @"maxlon",
                              @"maxalt",
                              @"maxspd",
                              @"ssid",       // MUST BE LAST!! 
                             nil] autorelease];
    
    }
    
    return self;
}

/*
- (id)initWithKismetResponse:(NSString *)response withServer:(KismetServer *)server
{
    self = [super init];
    self = [self init];
    
    if (self) {
        
        if(ignoreAP == nil)
            ignoreAP = [[IgnoreAP alloc] initWithServer:server];

    }    
    return self;
}
*/

- (void)processResponse:(NSString *)response
{
    NSError *error;
        
    if(ignoreAP == nil)
        ignoreAP = [[IgnoreAP alloc] init];
    
    
    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    
    
    // split input string by spaces
    NSArray *parts = [response componentsSeparatedByString:@" "];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // parse the input and place in a dictionary
    for(int a = 0; a < [self.capabilities count]; a++)
    {
        
        if(a < 2 || a == [self.capabilities count] - 1)
        {
            // string flavored
            [dict setObject:[parts objectAtIndex:(a + 1)] forKey:[self.capabilities objectAtIndex:a]];
        }
        else
        {
            // treat as decimal or int
            [dict setObject:[f numberFromString:[parts objectAtIndex:(a + 1)]] forKey:[self.capabilities objectAtIndex:a]];
        }
    }
    [f release];
    
    // assemble the ssid (may have multiple spaces in it)
    for(int a = [self.capabilities count] + 1; a < [parts count]; a++)
    {
        if([[parts objectAtIndex:(a)] length] > 0)
        {
            [dict setObject:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"ssid"], [parts objectAtIndex:(a)]] forKey:@"ssid"];        
        }
    }
    
    [dict setObject:[NSDate date] forKey:@"lastSeen"];
    
    [dict setObject:[[dict objectForKey:@"ssid"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"ssid"];
    
    if([ignoreAP.aps containsObject:[NSString stringWithFormat:@"%@%@", [dict objectForKey:@"ssid"], [dict objectForKey:@"bssid"]]])
    {
        return;
    }
    
    // check if this ap exists
    
    // Retrieve the entity from the local store -- much like a table in a database
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessPoint" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Set the predicate -- much like a WHERE statement in a SQL database
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ssid == %@ and bssid == %@ and self in %@", [dict objectForKey:@"ssid"], [dict objectForKey:@"bssid"], [server server_ap]];
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
        // UPDATE            
        //            NSLog(@"UPDATE: %@", [dict objectForKey:@"ssid"]);
        AccessPoint *existingAP = (AccessPoint *)[records objectAtIndex:0];
        [existingAP setValuesForKeysWithDictionary:dict];
        
        // this line might not be necessary - the last update date should be coming from the dict
        existingAP.lastSeen = [NSDate date];
    }
    else
    {
        // ADD
        //            NSLog(@"ADD: %@", [dict objectForKey:@"ssid"]);
        //            NSLog(@"Dict: %@", dict);
        AccessPoint *ap = (AccessPoint *)[NSEntityDescription insertNewObjectForEntityForName:@"AccessPoint" inManagedObjectContext:context];
        
        [dict setObject:[NSDate date] forKey:@"addedOn"];
        
        [ap setValuesForKeysWithDictionary:dict];
        [ap addAp_serverObject:server];
//        NSLog(@"AP: %@", ap);
    }
    
    [dict release];
    
    if(![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo],[error localizedDescription]);
        exit(-1);  // Fail
    }

}

- (NSString *)getNetworkCommand;
{
    NSMutableString *str = [[NSMutableString alloc] init];
    [str autorelease];
    [str appendString:@"ENABLE NETWORK "];
    for(int a = 0; a < [self.capabilities count]; a++)
    {
        if(a > 0)
            [str appendString:@","];
        
        [str appendString:[self.capabilities objectAtIndex:a]];
    }
    
    return str;
}

- (void)dealloc
{
    [capabilities release];
    capabilities = nil;
    [ignoreAP release];
    [super dealloc];
}

@end
