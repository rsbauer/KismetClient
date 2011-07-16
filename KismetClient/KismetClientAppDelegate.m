//
//  KismetClientAppDelegate.m
//  KismetClient
//
//  Created by Astro on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KismetClientAppDelegate.h"

@implementation KismetClientAppDelegate


@synthesize window=_window;
@synthesize messages;

// code from: http://www.raywenderlich.com/3932/how-to-create-a-socket-based-iphone-app-and-server

#pragma mark XIB flavored methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    messages = [[NSMutableArray alloc] init];	
    
    NSLog(@"Init Network");
    [self initNetworkCommunication];
    NSLog(@"Join Network");
    [self joinNetwork];
    NSLog(@"Joined");
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [messages release];

    [_window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Network communication

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    // CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.43.2", 2501, &readStream, &writeStream);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)@"tekro.com", 80, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)joinNetwork 
{
    NSString *response  = [NSString stringWithFormat:@"\n!0 REMOVE TIME\n!0 ENABLE NETWORK bssid,wep,ssid"];
    NSLog(@"build response");
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"*data setup");
	[outputStream write:[data bytes] maxLength:[data length]];    
    NSLog(@"data written");
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	NSLog(@"stream event %i", streamEvent);
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            NSLog(@"Stream has bytes availabe");
			break;			
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
            NSLog(@"Stream has ended");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}


- (void)messageReceived:(NSString *)message {
    NSLog(@"Message: %@", message);
	[messages addObject:message];
    //	[self.tView reloadData];
    
}


@end
