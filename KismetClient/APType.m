//
//  APType.m
//  KismetClient
//
//  Created by Robert Bauer on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APType.h"

@implementation APType

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)getTypeName:(int)typevalue
{
    if(typevalue == 0)
        return @"ap";
    
    if(typevalue == 1)
        return @"adhoc";
    
    if(typevalue == 2)
        return @"probe";

    if(typevalue == 3)
        return @"turbocell";

    if(typevalue == 4)
        return @"data";

    if(typevalue == 5)
        return @"remove";

    return @"";
}

@end
