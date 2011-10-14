//
//  ServerViewController.h
//  KismetClient
//
//  Created by Robert Bauer on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"
#import "KismetServer.h"

@interface ServerViewController : SecondLevelViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    NSArray *configItems;
    NSArray *dataItems;
    UITextField *serverName;
    UITextField *address;
    UITextField *port;
    KismetServer *server;
}

@property (nonatomic, retain) KismetServer *server;

- (void)cancelEdit:(id)sender;
- (void)saveEdit:(id)sender;
- (NSUInteger)numberOfServers;
@end
