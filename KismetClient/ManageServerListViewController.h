//
//  ManageServerListViewController.h
//  KismetClient
//
//  Created by Robert Bauer on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"
#import "KismetServer.h"

@interface ManageServerListViewController : SecondLevelViewController
{
    NSMutableArray *configs;

}

- (void)deleteServer:(KismetServer *)server;
@end
