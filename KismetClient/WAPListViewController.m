//
//  WAPListViewController.m
//  KismetClient
//
//  Created by Robert Bauer on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WAPListViewController.h"
#import "Connect.h"
#import "AccessPoint.h"
#import "KismetClientAppDelegate.h"
#import "WAPDetailView.h"
#import "MapViewController.h"

@implementation WAPListViewController

@synthesize server;

- (void)dealloc
{
    [server release];
    [connectKismet release];
    connectKismet = nil;
    [aps release];
    aps = nil;
    [super dealloc];
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
    return [aps count];
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
    
    AccessPoint *ap = (AccessPoint *)[aps objectAtIndex:[indexPath row]];
    
    // server names
    cell.textLabel.text = ap.ssid;
    [cell.textLabel setNumberOfLines:0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Ch: %@ Rate:%@", ap.bssid, ap.channel, ap.maxrate];
    
    return cell;
}

// table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WAPDetailView *detail = [[WAPDetailView alloc] init];
    detail.accessPoint = [aps objectAtIndex:[indexPath row]];
    detail.title = detail.accessPoint.ssid;

    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - UIView methods

- (void)viewDidLoad
{
    [self setEditing:YES animated:YES];
    connectKismet = [[Connect alloc] init];
    [connectKismet setServer:server];
    [connectKismet connect];
    
    if(aps != nil)
        [aps release];
    
    aps = [[NSMutableArray alloc] init];
    
    NSNotificationCenter *notifications = [NSNotificationCenter defaultCenter];
    [notifications addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [self contextDidSave:self];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // map
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMap:)] autorelease];
}

- (void)showMap:(id)sender
{
    /*
    // let the user know they do not have internet access
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon" 
                                                    message:@"Feature not implemented yet - will show a Google map with APs as markers." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
     */
    
    MapViewController *detail = [[MapViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)contextDidSave:(id)sender
{
    [aps removeAllObjects];
    
    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    // holder for the data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccessPoint" inManagedObjectContext:context];

    // fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    if([connectKismet isConnected] == YES)
        [fetchRequest setFetchLimit:10];
    
    // Set the predicate -- much like a WHERE statement in a SQL database
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self in %@", [server server_ap]];
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
                [aps addObject:ap];
            }
        }
    }

    [self.tableView reloadData];
}

@end
