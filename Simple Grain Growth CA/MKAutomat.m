//
//  MKAutomat.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKAutomat.h"
#include <stdlib.h>

@implementation MKAutomat

@synthesize x, y, boundaryType, neighborsType, lastId;

- (id)init
{
    self = [self initWithX:100
                         Y:100];
    return self;
}

- (id)initWithX:(NSInteger)X Y:(NSInteger)Y
{
    x = X;
    y = Y;
    boundaryType = periodicBoundaryConditions;
    NSMutableArray* caMutable = [NSMutableArray array];

    for (NSInteger a = 0; a < y; ++a) {
        [caMutable addObject:[[NSMutableArray alloc] init]];
        for (NSInteger b = 0; b < x; ++b) {
            [[caMutable objectAtIndex:a] addObject:[[MKCell alloc] init]];
        }
    }

    ca = [NSArray arrayWithArray:caMutable];
    caPrev = [ca copy];
    lastId = 0;
    return self;
}

- (NSInteger)andrzej
{
    NSInteger changes = 0;
    for (NSInteger a = 0; a < y; ++a) {
        for (NSInteger b = 0; b < x; ++b) {
            MKCell* currentCell = (MKCell*)[[ca objectAtIndex:a] objectAtIndex:b];
            if (currentCell.isLiving && currentCell.isOnBorder == NO) {
                continue;
            }
            NSSet* neighbors = [self getAllNeighborsForX:b
                                                    andY:a];

            NSMutableArray* neighborsIds = [NSMutableArray array];
            bool isOnBorder = NO;
            for (MKCell* neighbor in neighbors) {
                if (neighbor.grainId > 0) {
                    [neighborsIds addObject:[NSNumber numberWithInteger:neighbor.grainId]];
                }
                if (neighbor.grainId != currentCell.grainId) {
                    isOnBorder = YES;
                }
            }

            if (neighborsIds.count > 0) {
                currentCell.grainId = [[neighborsIds objectAtIndex:arc4random() % neighborsIds.count] intValue];
                currentCell.isLiving = YES;
                currentCell.isOnBorder = isOnBorder;
                ++changes;
            }
        }
    }

    caPrev = [ca copy];
    return changes;
}

- (NSSet*)getAllNeighborsForX:(NSInteger)X andY:(NSInteger)Y
{
    switch (self.boundaryType) {
    case periodicBoundaryConditions:
        return [self getAllNeighborsPeriodicBoundaryConditionsForX:X
                                                              andY:Y];
    case absorbingBoundaryConditions:
        return [self getAllNeighborsAbsorbingBoundaryConditionsForX:X
                                                               andY:Y];
    default:
        break;
    }
}

- (MKCell*)getX:(NSInteger)X Y:(NSInteger)Y
{
    return [[ca objectAtIndex:Y] objectAtIndex:X];
}

- (MKCell*)getPrevX:(NSInteger)X Y:(NSInteger)Y
{
    return [[caPrev objectAtIndex:Y] objectAtIndex:X];
}

- (NSSet*)getAllNeighborsPeriodicBoundaryConditionsForX:(NSInteger)X andY:(NSInteger)Y
{
    NSMutableSet* ansM = [NSMutableSet set];

    NSInteger XP = X + 1;
    NSInteger XM = X - 1;
    NSInteger YP = Y + 1;
    NSInteger YM = Y - 1;

    if (XP >= x) {
        XP = 0;
    }
    if (YP >= y) {
        YP = 0;
    }
    if (XM < 0) {
        XM = x - 1;
    }
    if (YM < 0) {
        YM = y - 1;
    }

    switch (self.neighborsType) {
    case MoorNeighborhood:
        [ansM addObject:[self getPrevX:XM
                                     Y:YM]];
        [ansM addObject:[self getPrevX:XM
                                     Y:Y]];
        [ansM addObject:[self getPrevX:XM
                                     Y:YP]];
        [ansM addObject:[self getPrevX:X
                                     Y:YM]];
        [ansM addObject:[self getPrevX:X
                                     Y:YP]];
        [ansM addObject:[self getPrevX:XP
                                     Y:YM]];
        [ansM addObject:[self getPrevX:XP
                                     Y:Y]];
        [ansM addObject:[self getPrevX:XP
                                     Y:YP]];
        break;
    case VonNeumannNeighborhood:
        [ansM addObject:[self getPrevX:X
                                     Y:YM]];
        [ansM addObject:[self getPrevX:X
                                     Y:YP]];
        [ansM addObject:[self getPrevX:XM
                                     Y:Y]];
        [ansM addObject:[self getPrevX:XP
                                     Y:Y]];

        break;

    default:
        break;
    }

    return ansM;
}

- (NSSet*)getAllNeighborsAbsorbingBoundaryConditionsForX:(NSInteger)X andY:(NSInteger)Y
{
    NSMutableSet* ansM = [NSMutableSet set];

    switch (self.neighborsType) {
    case MoorNeighborhood:
        [ansM addObject:[[caPrev objectAtIndex:Y - 1] objectAtIndex:X - 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y - 1] objectAtIndex:X]];
        [ansM addObject:[[caPrev objectAtIndex:Y - 1] objectAtIndex:X + 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y] objectAtIndex:X - 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y] objectAtIndex:X + 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y + 1] objectAtIndex:X - 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y + 1] objectAtIndex:X]];
        [ansM addObject:[[caPrev objectAtIndex:Y + 1] objectAtIndex:X + 1]];
        break;
    case VonNeumannNeighborhood:
        [ansM addObject:[[caPrev objectAtIndex:Y - 1] objectAtIndex:X]];
        [ansM addObject:[[caPrev objectAtIndex:Y] objectAtIndex:X - 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y] objectAtIndex:X + 1]];
        [ansM addObject:[[caPrev objectAtIndex:Y + 1] objectAtIndex:X]];
        break;

    default:
        break;
    }

    return ansM;
}

- (NSInteger)addNewGrainAtX:(NSInteger)X Y:(NSInteger)Y
{
    MKCell* curentCell = [[ca objectAtIndex:Y] objectAtIndex:X];

    ++lastId;
    curentCell.grainId = self.lastId;

    return self.lastId;
}

- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithR:(NSInteger)R
{
    MKCell* curentCell = [[ca objectAtIndex:Y] objectAtIndex:X];

    if (curentCell.grainId == 0 || curentCell.isOnBorder) {
        for (NSInteger a = Y - R; a < Y + R; ++a) {
            for (NSInteger b = X - R; b < X + R; ++b) {
                if ((a - Y) * (a - Y) + (b - X) * (b - X) < R * R) {
                    MKCell* cellInR = [[ca objectAtIndex:Y] objectAtIndex:X];
                    cellInR.grainId = -1;
                    cellInR.isLiving = YES;
                    cellInR.isLiving = YES;
                }
            }
        }
        return YES;
    }

    return NO;
}

- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithD:(NSInteger)D
{
    MKCell* curentCell = [[ca objectAtIndex:Y] objectAtIndex:X];

    if (curentCell.grainId == 0 || curentCell.isOnBorder) {
        for (NSInteger a = Y - D; a < Y + D; ++a) {
            for (NSInteger b = X - D; b < X + D; ++b) {
                MKCell* cellInD = [[ca objectAtIndex:Y] objectAtIndex:X];
                cellInD.grainId = -1;
                cellInD.isLiving = YES;
                cellInD.isLiving = YES;
            }
        }
        return YES;
    }

    return NO;
}

@end
