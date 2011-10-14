//
//  Connect.h
//  KismetClient
//
//  Created by Robert Bauer on 9/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "KismetServer.h"
#import "KismetNetwork.h"

#define TIMEOUT 30

typedef enum {
    TAG_CMD,
    TAG_DATA
} TAGLIST;

@interface Connect : NSObject
{
    AsyncSocket *asyncSocket;
    
    KismetServer *server;
    KismetNetwork *network;
}

@property (nonatomic, retain) KismetServer *server;

- (void)connect;
- (void)readKismet;
- (BOOL)isConnected;

@end
