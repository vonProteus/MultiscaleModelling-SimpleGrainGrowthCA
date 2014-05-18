//
//  MKCell.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKCell.h"

@implementation MKCell
@synthesize isOnBorder, isLiving, grainId, coordinateX, coordinateY, willGrow, wasChanged, wasRecristalized, energy;
- (id)init
{
    self.coordinateX = 0;
    self.coordinateY = 0;
    [self clear];
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
    self.wasChanged = hear.wasChanged;
    self.wasRecristalized = hear.wasRecristalized;
    self.energy = hear.energy;
    return self;
}

- (void)clear
{
    self.grainId = 0;
    self.isLiving = NO;
    self.isOnBorder = YES;
    self.willGrow = YES;
    self.wasChanged = NO;
    self.wasRecristalized = NO;
    self.energy = 0;
}
@end
