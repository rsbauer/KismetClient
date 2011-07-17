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
//    NSData *data;
    NSNumber *bytesRead;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSMutableArray *messages;
// @property (nonatomic, retain) NSData *data;

- (void)initNetworkCommunication;
- (void)joinNetwork;
- (void)closeStreams;
- (void)readIn:(NSString *)s;
- (void)writeOut:(NSString *)s; 


@end
