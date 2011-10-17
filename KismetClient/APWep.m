//
//  APWep.m
//  KismetClient
//
//  Created by Robert Bauer on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APWep.h"

@implementation APWep

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)getWepName:(int)crypt
{
    NSMutableString *wep = [[NSMutableString alloc] init];
    
    if(crypt & 0x0002)
        [wep appendString:@"WEP "];
    
    if (crypt & 0x0004)
        [wep appendString:@"L3 "];

    if (crypt & 0x0008)
        [wep appendString:@"WEP40 "];

    if (crypt & 0x0010)
        [wep appendString:@"WEP104 "];

    if (crypt & 0x0020)
        [wep appendString:@"TKIP "];

    if (crypt & 0x0040)
        [wep appendString:@"WPA "];
    
    if (crypt & 0x0080)
        [wep appendString:@"PSK "];

    if (crypt & 0x0100)
        [wep appendString:@"AES OCB "];

    if (crypt & 0x0200)
        [wep appendString:@"AES CCM "];

    if (crypt & 0x0400)
        [wep appendString:@"LEAP "];

    if (crypt & 0x0800)
        [wep appendString:@"TTLS "];

    if (crypt & 0x1000)
        [wep appendString:@"TLS "];

    if (crypt & 0x2000)
        [wep appendString:@"PEAP "];

    if (crypt & 0x4000)
        [wep appendString:@"ISAKMP "];

    if (crypt & 0x8000)
        [wep appendString:@"PPTP "];

    if([wep length] == 0)
    {
        [wep release];
        return @"NONE";    
    }
    
    return [wep autorelease];
}

@end
