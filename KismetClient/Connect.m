//
//  Connect.m
//  KismetClient
//
//  Created by Robert Bauer on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Connect.h"

@implementation Connect

@synthesize server;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [server release];
    [asyncSocket setDelegate:nil];
    [asyncSocket release];
    asyncSocket = nil;
    network = nil;
    [network release];
    [super dealloc];
}


- (void)connect
{
    network = [[KismetNetwork alloc] init];
    network.server = server;
    
    NSError *error = nil;
    
    if(asyncSocket == nil)
    {
        asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    
    [asyncSocket connectToHost:server.address onPort:[server.port intValue] withTimeout:TIMEOUT error:&error];
    
    //    NSData *msg = [[NSString stringWithFormat:@"\n!0 REMOVE TIME\n!0 %@\n!0 ENABLE INFO networks\n", [kismetNetwork getNetworkCommand]] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *msg = [[NSString stringWithFormat:@"\n!0 REMOVE TIME\n!0 %@\n", [network getNetworkCommand]] dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:msg withTimeout:TIMEOUT tag:TAG_CMD];
    
    if(error != nil)
    {
        NSLog(@"Error: %@", error);
    }
}


- (void)onSocket:(AsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_DATA)
    {
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];        
        
        if ([output rangeOfString:@"*NETWORK"].location != NSNotFound) {
            // KismetNetwork *network = [[KismetNetwork alloc] initWithKismetResponse:output withServer:server];
            //[network release];
            [network processResponse:output];
        } 

//        NSLog(@"TAG_DATA: %@", output);
        [output release];
    }
    
    [self readKismet];
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)remoteHost port:(UInt16)remotePort
{
//	NSLog(@"Socket is connected!");
	
//	NSLog(@"Remote Address: %@:%hu", remoteHost, remotePort);
	
//	NSString *localHost = [sock localHost];
//	UInt16 localPort = [sock localPort];
	
//	NSLog(@"Local Address: %@:%hu", localHost, localPort);
    
    [self readKismet];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)error
{
//    NSLog(@"Disconnect w/error: %@", error);
    if(error != nil)
    {
        // sleep for 2 seconds
        [sock disconnect];
        [asyncSocket release];
        asyncSocket = nil;
        [network release];
        network = nil;
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(connect)
                                       userInfo:nil
                                        repeats:NO];        
    }
}

- (void)readKismet
{
    NSData *msg = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket readDataToData:msg withTimeout:TIMEOUT tag:TAG_DATA];
}


- (BOOL)isConnected
{
    return [asyncSocket isConnected];
}
@end
