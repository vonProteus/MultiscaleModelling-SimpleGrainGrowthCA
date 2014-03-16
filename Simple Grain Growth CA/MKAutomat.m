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
    self = [self initWithX:50
                         Y:50];
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

    NSMutableArray* caPrevMutable = [NSMutableArray array];
    for (NSInteger a = 0; a < y; ++a) {
        [caPrevMutable addObject:[[NSMutableArray alloc] init]];
        for (NSInteger b = 0; b < x; ++b) {
            [[caPrevMutable objectAtIndex:a] addObject:[[MKCell alloc] init]];
        }
    }

    caPrev = [NSArray arrayWithArray:caPrevMutable];

    lastId = 0;
    absorbingCell = [[MKCell alloc] init];
    absorbingCell.grainId = -1;
    absorbingCell.isLiving = YES;
    absorbingCell.isOnBorder = YES;

    return self;
}

- (NSInteger)andrzej
{
    NSInteger changes = 0;
    for (NSInteger a = 0; a < y; ++a) {
        for (NSInteger b = 0; b < x; ++b) {
            MKCell* currentCell = [self getX:b
                                           Y:a];
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

            if (currentCell.grainId != -1) {
                if (neighborsIds.count > 0) {
                    currentCell.grainId = [[neighborsIds objectAtIndex:arc4random() % neighborsIds.count] intValue];
                    currentCell.isLiving = YES;
                    currentCell.isOnBorder = isOnBorder;
                    ++changes;
                }
            }
        }
    }

    //    [self allToLog];

    for (NSInteger a = 0; a < y; ++a) {
        for (NSInteger b = 0; b < x; ++b) {
            MKCell* currentCell = [self getX:b
                                           Y:a];
            MKCell* prevCell = [self getPrevX:b
                                            Y:a];
            [prevCell getAllFrom:currentCell];
        }
    }

    DLog("number of changes %li", changes);
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
    MKCell* curentCell = [self getX:X
                                  Y:Y];

    ++lastId;
    curentCell.grainId = self.lastId;
    curentCell.isLiving = YES;
    curentCell.isOnBorder = YES;

    //    [self allToLog];

    return self.lastId;
}

- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithR:(NSInteger)R
{
    MKCell* curentCell = [self getX:X
                                  Y:Y];

    if (curentCell.grainId == 0 || curentCell.isOnBorder) {
        for (NSInteger a = Y - R; a < Y + R; ++a) {
            for (NSInteger b = X - R; b < X + R; ++b) {
                if ((a - Y) * (a - Y) + (b - X) * (b - X) < R * R) {
                    MKCell* cellInR = [self getX:b
                                               Y:a];
                    MKCell* cellPrevInR = [self getPrevX:b
                                                       Y:a];
                    cellInR.grainId = -1;
                    cellInR.isLiving = YES;
                    cellInR.isOnBorder = NO;
                    [cellPrevInR getAllFrom:cellPrevInR];
                }
            }
        }
        //        [self allToLog];

        return YES;
    }
    //    [self allToLog];

    return NO;
}

- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithD:(NSInteger)D
{
    MKCell* curentCell = [self getX:X
                                  Y:Y];

    if (curentCell.grainId == 0 || curentCell.isOnBorder) {
        for (NSInteger a = Y - D; a < Y + D; ++a) {
            for (NSInteger b = X - D; b < X + D; ++b) {
                MKCell* cellInD = [self getX:b
                                           Y:a];
                MKCell* cellPrevInD = [self getPrevX:b
                                                   Y:a];
                cellInD.grainId = -1;
                cellInD.isLiving = YES;
                cellInD.isOnBorder = NO;
                [cellPrevInD getAllFrom:cellPrevInD];
            }
        }
        //        [self allToLog];
        return YES;
    }
    //    [self allToLog];

    return NO;
}

- (void)allToLog
{
    NSMutableString* s = [NSMutableString stringWithFormat:@"\n"];

    [s appendString:@"CA\n"];

    for (NSInteger a = 0; a < y; ++a) {
        for (NSInteger b = 0; b < x; ++b) {
            [s appendFormat:@"%li ", [self getX:b
                                              Y:a].grainId];
        }
        [s appendString:@"\n"];
    }

    [s appendString:@"CAPrev\n"];

    for (NSInteger a = 0; a < y; ++a) {
        for (NSInteger b = 0; b < x; ++b) {
            [s appendFormat:@"%li ", [self getPrevX:b
                                                  Y:a].grainId];
        }
        [s appendString:@"\n"];
    }
    DLog("%@", s);
}

@end
