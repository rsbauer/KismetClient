//
//  KismetClientAppDelegate.h
//  KismetClient
//
//  Created by Astro on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

#define TIMEOUT 30

typedef enum {
    TAG_CMD,
    TAG_DATA
} TAGLIST;


@interface KismetClientAppDelegate : NSObject <UIApplicationDelegate> {

    AsyncSocket *asyncSocket;

}


@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)connect;

- (void)readKismet;

@end
