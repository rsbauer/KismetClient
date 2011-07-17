//
//  KismetClientAppDelegate.h
//  KismetClient
//
//  Created by Astro on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ULINetSocket;

@interface KismetClientAppDelegate : NSObject <UIApplicationDelegate> {

    ULINetSocket *mSocket;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)connect;


@end
