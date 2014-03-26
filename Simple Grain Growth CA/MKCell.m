//
//  MKCell.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKCell.h"

@implementation MKCell
@synthesize isOnBorder, isLiving, grainId, coordinateX, coordinateY, willGrow;
- (id)init
{
    self.coordinateX = 0;
    self.coordinateY = 0;
    self.grainId = 0;
    self.isLiving = NO;
    self.isOnBorder = YES;
    self.willGrow = YES;
    return self;
}

- (MKCell*)getAllFrom:(MKCell*)hear
{
    self.coordinateX = hear.coordinateX;
    self.coordinateY = hear.coordinateY;
    self.grainId = hear.grainId;
    self.isLiving = hear.isLiving;
    self.isOnBorder = hear.isOnBorder;
    self.willGrow = hear.willGrow;
    return self;
}

@end
