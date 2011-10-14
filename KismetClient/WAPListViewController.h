//
//  WAPListViewController.h
//  KismetClient
//
//  Created by Robert Bauer on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"
#import "KismetServer.h"
#import "Connect.h"

@interface WAPListViewController : SecondLevelViewController
{
    Connect *connectKismet;
    NSMutableArray *aps;
}

@property (nonatomic, retain) KismetServer *server;


- (void)showMap:(id)sender;
- (void)contextDidSave:(id)sender;

@end
