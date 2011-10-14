//
//  KismetNetwork.h
//  KismetClient
//
//  Created by Robert Bauer on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KismetServer.h"
#import "IgnoreAP.h"

@interface KismetNetwork : NSObject
{
    NSArray *capabilities;
    NSArray *ignoreList;
    IgnoreAP *ignoreAP;
    KismetServer *server;
}

@property (nonatomic, retain) NSArray *capabilities;
@property (nonatomic, retain) KismetServer *server;

//- (id)initWithKismetResponse:(NSString *)response withServer:(KismetServer *)server;
- (NSString *)getNetworkCommand;
- (void)processResponse:(NSString *)response;

@end
