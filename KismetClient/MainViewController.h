//
//  MainViewController.h
//  KismetClient
//
//  Created by Robert Bauer on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewController : UITableViewController
{
    NSArray *controllers;
    NSMutableArray *configs;

}

- (void)accessoryAction:(id)sender;
- (void)doEdit:(id)sender;
- (void)addDefaultLocation;
@end
