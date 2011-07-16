//
//  KismetClientAppDelegate.h
//  KismetClient
//
//  Created by Astro on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;


@interface KismetClientAppDelegate : NSObject <UIApplicationDelegate, NSStreamDelegate> {
    NSMutableArray *messages;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSMutableArray *messages;

-(void)initNetworkCommunication;
-(void)joinNetwork;


@end
