//
//  MKCell.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKCell.h"

@implementation MKCell
@synthesize isOnBorder, isLiving, grainId;
- (id)init
{
    self.grainId = 0;
    self.isLiving = NO;
    self.isOnBorder = YES;
    return self;
}

- (MKCell*)getAllFrom:(MKCell*)hear
{
    self.grainId = hear.grainId;
    self.isLiving = hear.isLiving;
    self.isOnBorder = hear.isOnBorder;
    return self;
}

@end
