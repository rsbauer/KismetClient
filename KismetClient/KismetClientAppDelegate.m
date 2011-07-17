//
//  KismetClientAppDelegate.m
//  KismetClient
//
//  Created by Astro on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KismetClientAppDelegate.h"
#import "ULINetSocket.h"

@implementation KismetClientAppDelegate

@synthesize window=_window;

// @synthesize readStream, writeStream;

// code from: http://stackoverflow.com/questions/3965370/problem-with-the-writing-tcp-socket-in-objective-c-error-message


#pragma mark XIB flavored methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Use the NetSocket convenience method to ignore broken pipe signals
    [ULINetSocket ignoreBrokenPipes];
    
    [self connect];
    
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
    [mSocket release];
    mSocket = nil;
    
    [_window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Network communication

- (id)init
{
    if( ![super init] )
        return nil;
    
    mSocket = nil;
    
    return self;
}


- (void)connect
{
    // Create a new ULINetSocket connected to the host. Since ULINetSocket is asynchronous, the socket is not
    // connected to the host until the delegate method is called.
    mSocket = [[ULINetSocket netsocketConnectedToHost:@"192.168.43.2" port:2501] retain];
    
    // Schedule the ULINetSocket on the current runloop
    [mSocket scheduleOnCurrentRunLoop];
    
    // Set the ULINetSocket's delegate to ourself
    [mSocket setDelegate:self];
}

#pragma mark -

- (void)netsocketConnected:(ULINetSocket*)inNetSocket
{
    NSLog( @"Socket Connected" );
    
    // Send a simple HTTP 1.0 header to the server and hopefully we won't be rejected
    [mSocket writeString:@"\n!0 REMOVE TIME\n!0 ENABLE NETWORK bssid,wep,ssid\n!0 ENABLE INFO networks\n" encoding:NSUTF8StringEncoding];
}

- (void)netsocketDisconnected:(ULINetSocket*)inNetSocket
{
//    NSString* path;
//    NSString* data;
    
    NSLog( @"Socket Disconnected" );
    
    // Determine path for writing page to disk
    // path = [@"~/GET Example Download.html" stringByExpandingTildeInPath];
    
    // Read downloaded page from socket. Since ULINetSocket buffers available data for you
    // you can wait for your socket to disconnect and then read the data at once
    // data = [mSocket readString:NSUTF8StringEncoding];
    
    // Write downloaded page to disk
    // [data writeToFile: path atomically: YES encoding: NSUTF8StringEncoding error: nil];
    
    // NSLog( @"GET Example: Saved downloaded page to %@", path );
}

- (void)netsocket:(ULINetSocket*)inNetSocket dataAvailable:(unsigned)inAmount
{
//    NSLog( @"Socket: Data available (%u)", inAmount );
//    NSString *data;
    NSString *data; 
    data = [mSocket readString:NSUTF8StringEncoding];
    NSLog(@"!>%@\n", data);
    

}

- (void)netsocketDataSent:(ULINetSocket*)inNetSocket
{
    NSLog( @"Socket: Data sent" );
}



@end
