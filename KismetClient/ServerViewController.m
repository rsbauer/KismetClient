//
//  ServerViewController.m
//  KismetClient
//
//  Created by Robert Bauer on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerViewController.h"
#import "KismetServer.h"
#import "KismetClientAppDelegate.h"

@implementation ServerViewController
@synthesize server;

-(void)viewDidLoad
{
    [self setEditing:YES animated:YES];
    configItems = [[NSArray alloc] initWithObjects:@"Name", @"Address", @"Port", nil];
    dataItems = [[NSArray alloc] initWithObjects:@"Clear Collected Access Points", nil];
    
    [self.tableView setAutoresizesSubviews:YES];

    [super viewDidLoad];
}


-(void)viewDidUnload
{
    [dataItems release];
    [configItems release];
    [super viewDidUnload];
}

-(void)dealloc
{
    [dataItems release];
    [configItems release];
    [super dealloc];
}

#pragma mark - Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.server != nil)
        return 2;

    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
        {
            return @"Connection Settings";
            break;
        }
        case 1:
        {
            return @"Local Data";
            break;
        }
    }
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [configItems count];
    return [dataItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *editCellId = @"secondLevelCellId";
    static NSString *detailCellId = @"secondLevelCellId";

    if([indexPath section] == 0)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:editCellId];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:editCellId] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setAutoresizesSubviews:YES];
            
            if ([indexPath section] == 0) {
                
                UITextField *textField = nil;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [textField release];
                    textField = [[UITextField alloc] initWithFrame:CGRectMake(170, 6, 540, 30)];
                }
                else
                {
                    textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
                }
                
                textField.adjustsFontSizeToFitWidth = YES;
                textField.textColor = [UIColor blackColor];
                
                switch([indexPath row])
                {
                    case 0:
                    {
                        if(self.server != nil)
                            textField.text = server.serverName;
                        
                        textField.placeholder = @"Name";
                        textField.keyboardType = UIKeyboardTypeAlphabet;
                        textField.returnKeyType = UIReturnKeyDone;
                        serverName = textField;
                        break;
                    }
                    case 1:
                    {
                        if(self.server != nil)
                            textField.text = server.address;
                        
                        textField.placeholder = @"Address";
                        textField.keyboardType = UIKeyboardTypeAlphabet;
                        textField.returnKeyType = UIReturnKeyDone;
                        address = textField;
                        break;
                    }
                    case 2:
                    {
                        textField.text = @"2501";
                        
                        if(self.server != nil)
                            textField.text = server.port;
                        
                        textField.placeholder = @"2501";
                        textField.keyboardType = UIKeyboardTypeNumberPad;
                        textField.returnKeyType = UIReturnKeyDone;
                        port = textField;
                        break;
                    }
                }
                
                textField.backgroundColor = [UIColor whiteColor];
                textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
                textField.textAlignment = UITextAlignmentLeft;
                textField.tag = [indexPath row];
                textField.delegate = self;
                
                textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
                [textField setEnabled: YES];
                
                [cell addSubview:textField];
                
                [textField release];
            }
        }
        cell.textLabel.text = [configItems objectAtIndex:[indexPath row]];
        return cell;
    }
    
    if([indexPath section] == 1)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:detailCellId];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:detailCellId] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setAutoresizesSubviews:YES];
        }

        cell.textLabel.text = [dataItems objectAtIndex:[indexPath row]];    
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Access Points: %d", [self numberOfServers]];
        return cell;
    }
    
    return nil;
}

// table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     SecondLevelViewController *nextController = [controllers objectAtIndex:[indexPath row]];
     [self.navigationController pushViewController:nextController animated:YES];
     */
    
    if([indexPath section] == 1)
    {
        if([indexPath row] == 0)
        {
            // clear AccessPoint data for this server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear" message:@"Do you want to remove all access points for this server?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        // cancel
    }
    else
    {
        // ok
        NSError *error = nil;
        NSNumber *orderingValue = server.orderingValue;
        
        // managed object context is where all the operations are happening
        NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
        
        [context deleteObject:server];
        //[server release];
        
        KismetServer *newServer = nil;
        
        newServer = (KismetServer *)[NSEntityDescription insertNewObjectForEntityForName:@"KismetServer" inManagedObjectContext:context];
        
        newServer.serverName = serverName.text;
        newServer.address = address.text;
        newServer.port = port.text;
        newServer.orderingValue = orderingValue;
        
        [self setServer:newServer];
        
        [context save:&error];
        
        if(error)
        {
            NSLog(@"%@", error);
        }


        
        [self.tableView reloadData];
    }
}



#pragma mark - UIView methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // cancel
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit:)] autorelease];
    // save
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEdit:)] autorelease];
}


- (void)cancelEdit:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)saveEdit:(id)sender
{
    NSError *err = nil;

    // managed object context is where all the operations are happening
    NSManagedObjectContext *context = ((KismetClientAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    
    KismetServer *newServer = nil;
    if(self.server == nil)
    {
        // add
        newServer = (KismetServer *)[NSEntityDescription insertNewObjectForEntityForName:@"KismetServer" inManagedObjectContext:context];
    }
    else
    {
        
        // Retrieve the entity from the local store -- much like a table in a database
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"KismetServer" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        // Set the predicate -- much like a WHERE statement in a SQL database
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serverName == %@ and address == %@ and port == %@ and orderingValue == %@", self.server.serverName, self.server.address, self.server.port, self.server.orderingValue];
        [request setPredicate:predicate];
        
        // Set the sorting -- mandatory, even if you're fetching a single record/object
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderingValue" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release]; sortDescriptors = nil;
        [sortDescriptor release]; sortDescriptor = nil;
        
        // Request the data -- NOTE, this assumes only one match, that 
        // yourIdentifyingQualifier is unique. It just grabs the first object in the array. 
        newServer = (KismetServer *)[[context executeFetchRequest:request error:&err] objectAtIndex:0];
        [request release]; 
        request = nil;
    }
        
    newServer.serverName = serverName.text;
    newServer.address = address.text;
    newServer.port = port.text;
    newServer.orderingValue = [NSNumber numberWithInt:1];
        
    [context save:&err];
    
    if(err)
    {
        NSLog(@"%@", err);
    }
    // return to the main view
    [self.navigationController popViewControllerAnimated: YES];
}

- (NSUInteger)numberOfServers
{
    if(self.server == nil)
    {
        return 0;
    }
    
    return [[server server_ap] count];
}

#pragma mark - UITextField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /*
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    
    UIResponder *nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) 
    {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } 
    else 
    {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
     */
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
