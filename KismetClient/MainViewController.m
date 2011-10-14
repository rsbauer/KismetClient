//
//  MainViewController.m
//  KismetClient
//
//  Created by Robert Bauer on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SecondLevelViewController.h"
#import "ServerViewController.h"
#import "KismetClientAppDelegate.h"
#import "ManageServerListViewController.h"
#import "WAPListViewController.h"

#define DEFAULT_SERVERNAME @"Kismet Server Demo"
#define DEFAULT_ADDRESS @"192.168.2.102"
#define DEFAULT_PORT @"2500"


@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    if(configs != nil)
        [configs release];
    
    configs = [[NSMutableArray alloc] init];

    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    // holder for the data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KismetServer" inManagedObjectContext:context];
    
    
    // fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    // set sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderingValue" ascending:YES];
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

            for(KismetServer *server in searchResults)
            {
                [configs addObject:server];
            }
        }
        else
        {
            [self addDefaultLocation];
        }
    }

    ServerViewController *serverView = [[ServerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    serverView.title = @"Add Configuration";

    NSArray *commands = [[NSArray alloc] initWithObjects:serverView, nil];
    
    if(controllers != nil)
        [controllers release];
    
    controllers = [[NSArray alloc] initWithObjects:[configs retain], commands, nil];
    
    [serverView release];
    [commands release];
    [configs release];

    [self.tableView setAutoresizesSubviews:YES];

    [self.tableView reloadData];
}



-(void)viewDidLoad
{
    [self setEditing:YES animated:YES];

    [super viewDidLoad];
}


-(void)viewDidUnload
{
    [controllers release];
    [configs release];
    configs = nil;
    controllers = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    [configs release];
    [controllers release];
    configs = nil;
    controllers = nil;
    [super dealloc];
}

// table datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [controllers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
        {
            return @"Choose a Configuration";
            break;
        }
    }
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[controllers objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *serverCellId = @"serverCellId";
    static NSString *configCellId = @"configCellId";
    
    UITableViewCell *cell = nil;  
    if([indexPath section] == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:serverCellId];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:configCellId];
    }
    
    // check if the cell is nil, if so, figure out which one to load
    if(cell == nil)
    {
        if([indexPath section] == 0)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:serverCellId] autorelease];
        }
        else
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:configCellId] autorelease];
            
        }

        [cell setAutoresizesSubviews:YES];
    }
    
    // check if in nav section
    if([indexPath section] == 1)
    {
        // show config menu button
        SecondLevelViewController *viewController = [[controllers objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        cell.textLabel.text = viewController.title;
    }
    else
    {
        // server names
        cell.textLabel.text = ((KismetServer *)[configs objectAtIndex:[indexPath row]]).serverName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@", ((KismetServer *)[configs objectAtIndex:[indexPath row]]).address, ((KismetServer *)[configs objectAtIndex:[indexPath row]]).port];
        
        UIButton *accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        accessory.tag = [indexPath row];
        accessory.userInteractionEnabled = YES;
        [accessory addTarget:self action:@selector(accessoryAction:) forControlEvents:UIControlEventTouchDown];
        
        cell.accessoryView = accessory;
    }
    
    return cell;
}

// table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 1)
    {
        SecondLevelViewController *viewController = [[controllers objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        viewController.title = @"Add Configuration";
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        WAPListViewController *viewController = [[WAPListViewController alloc] init];
        viewController.title = @"AP List";
        viewController.server = (KismetServer *)[configs objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)accessoryAction:(id)sender
{
    UIButton *button = sender;
    ServerViewController *viewController = [[controllers objectAtIndex:1] objectAtIndex:0];
    viewController.title = @"Edit Configuration";
    viewController.server = ((KismetServer *)[configs objectAtIndex:button.tag]); 
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // edit
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doEdit:)] autorelease];
}

- (void)doEdit:(id)sender
{
    SecondLevelViewController *manageView = [[ManageServerListViewController alloc] init];
    manageView.title = @"Manage List";
    [self.navigationController pushViewController:manageView animated:YES];
    [manageView release];
}

- (void)addDefaultLocation
{
    NSError *err = nil;
    
    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    
    KismetServer *newServer = (KismetServer *)[NSEntityDescription insertNewObjectForEntityForName:@"KismetServer" inManagedObjectContext:context];

    
    newServer.serverName = DEFAULT_SERVERNAME;
    newServer.address = DEFAULT_ADDRESS;
    newServer.port = DEFAULT_PORT;
    newServer.orderingValue = [NSNumber numberWithInt:1];
    
    [context save:&err];
    [configs addObject:newServer];

    if(err)
    {
        NSLog(@"%@", err);
    }
}

@end
