//
//  ManageServerListViewController.m
//  KismetClient
//
//  Created by Robert Bauer on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManageServerListViewController.h"
#import "SecondLevelViewController.h"
#import "ServerViewController.h"
#import "KismetClientAppDelegate.h"
#import "ManageServerListViewController.h"

@implementation ManageServerListViewController
-(void)viewWillAppear:(BOOL)animated
{
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
            int a = 0;
            for(KismetServer *server in searchResults)
            {
                server.orderingValue = [NSNumber numberWithInteger:a];
                [configs addObject:server];
                a++;
                [context save:nil];
            }
        }
        else
        {
            // no locations saved
        }
    }
        
    [self.tableView setAutoresizesSubviews:YES];
    [self.tableView reloadData];
}



-(void)viewDidLoad
{
    [self.tableView setEditing:YES animated:YES];

    [super viewDidLoad];
}


-(void)viewDidUnload
{
    [configs removeAllObjects];
    [configs release];
    configs = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    [configs removeAllObjects];
    [configs release];
    configs = nil;
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
    return [configs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *configCellId = @"configCellId";
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:configCellId];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:configCellId] autorelease];
        [cell setAutoresizesSubviews:YES];
    }
    
    // server names
    cell.textLabel.text = ((KismetServer *)[configs objectAtIndex:[indexPath row]]).serverName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@", ((KismetServer *)[configs objectAtIndex:[indexPath row]]).address, ((KismetServer *)[configs objectAtIndex:[indexPath row]]).port];

    return cell;
}

// table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteServer:[configs objectAtIndex:[indexPath row]]];
        [configs removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)indexPath
{ return YES; }

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
    
    id object = [[configs objectAtIndex:[fromIndexPath row]] retain];
    [configs removeObjectAtIndex:[fromIndexPath row]];
    [configs insertObject:object atIndex:[toIndexPath row]];
    [object release];                 
    
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;

    for(int a = 0; a < [configs count]; a++)
    {
        ((KismetServer *)[configs objectAtIndex:a]).orderingValue = [NSNumber numberWithInteger:a];
        [context save:nil];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // edit
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doEdit:)] autorelease];
}

#pragma mark - core data functions

- (void)deleteServer:(KismetServer *)server
{
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    [context deleteObject:server];
    [context save:nil];
}


@end
