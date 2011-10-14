//
//  IgnoreNetwork.h
//  KismetClient
//
//  Created by Robert Bauer on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "KismetServer.h"

@interface IgnoreAP : NSObject
{
    NSMutableArray *aps;
}

@property (nonatomic, retain) NSMutableArray *aps;

// - (id)initWithServer:(KismetServer *)server;

@end
