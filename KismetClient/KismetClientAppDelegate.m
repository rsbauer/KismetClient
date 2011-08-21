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

// AsyncSocket:  http://code.google.com/p/cocoaasyncsocket/

#pragma mark XIB flavored methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    
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
    asyncSocket = nil;
    [asyncSocket release]; 
    
    [_window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Network communication

- (id)init
{
    if( ![super init] )
        return nil;
        
    return self;
}


- (void)connect
{
    [asyncSocket connectToHost:@"192.168.2.102" onPort:9000 error:nil];
    NSData *msg = [@"\n!0 REMOVE TIME\n!0 ENABLE NETWORK bssid,wep,ssid\n!0 ENABLE INFO networks\n" dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:msg withTimeout:TIMEOUT tag:TAG_CMD];
    
}


- (void)onSocket:(AsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_DATA)
    {
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"TAG_DATA: %@", output);
        [output release];
    }
    
    [self readKismet];
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)remoteHost port:(UInt16)remotePort
{
	NSLog(@"Socket is connected!");
	
	NSLog(@"Remote Address: %@:%hu", remoteHost, remotePort);
	
	NSString *localHost = [sock localHost];
	UInt16 localPort = [sock localPort];
	
	NSLog(@"Local Address: %@:%hu", localHost, localPort);
    
    [self readKismet];
}

- (void)readKismet
{
    NSData *msg = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];

    [asyncSocket readDataToData:msg withTimeout:TIMEOUT tag:TAG_DATA];
}



@end
