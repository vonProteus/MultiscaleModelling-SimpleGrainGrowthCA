//
//  MKAutomat.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKAutomat.h"
#import <stdlib.h>

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
    NSMutableSet* ansM = [NSMutableSet set];

    NSInteger XP = X + 1;
    NSInteger XM = X - 1;
    NSInteger YP = Y + 1;
    NSInteger YM = Y - 1;

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

    case Hex1:
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
        break;
    case Hex2:
        [ansM addObject:[self getPrevX:XM
                                     Y:YM]];
        [ansM addObject:[self getPrevX:XM
                                     Y:Y]];
        [ansM addObject:[self getPrevX:X
                                     Y:YM]];
        [ansM addObject:[self getPrevX:X
                                     Y:YP]];
        [ansM addObject:[self getPrevX:XP
                                     Y:Y]];
        [ansM addObject:[self getPrevX:XP
                                     Y:YP]];
        break;

    case HexRandom:
        [ansM addObject:[self getPrevX:X
                                     Y:YM]];
        [ansM addObject:[self getPrevX:X
                                     Y:YP]];
        [ansM addObject:[self getPrevX:XM
                                     Y:Y]];
        [ansM addObject:[self getPrevX:XP
                                     Y:Y]];

        NSInteger h1 = arc4random() % 4;
        NSInteger h2 = arc4random() % 4;
        while (h1 == h2) {
            h2 = arc4random() % 4;
        }

        [ansM addObject:[self getPrevCorner:h1
                                          X:X
                                          Y:Y]];
        [ansM addObject:[self getPrevCorner:h2
                                          X:X
                                          Y:Y]];

    default:
        break;
    }

    return ansM;
}

- (MKCell*)getX:(NSInteger)X Y:(NSInteger)Y
{
    switch (self.boundaryType) {
    case periodicBoundaryConditions:
        if (Y >= y) {
            Y -= y;
        }
        if (X >= x) {
            X -= x;
        }
        if (Y < 0) {
            Y += y;
        }
        if (X < 0) {
            X += x;
        }

        return [[ca objectAtIndex:Y] objectAtIndex:X];
    case absorbingBoundaryConditions:
        if (X >= x || Y >= y || X < 0 || Y < 0) {
            return [[[MKCell alloc] init] getAllFrom:absorbingCell];
        } else {
            return [[ca objectAtIndex:Y % y] objectAtIndex:X % x];
        }
    default:
        break;
    }

    return nil;
}

- (MKCell*)getPrevCorner:(NSInteger)Corner X:(NSInteger)X Y:(NSInteger)Y
{
    NSInteger XP = X + 1;
    NSInteger XM = X - 1;
    NSInteger YP = Y + 1;
    NSInteger YM = Y - 1;

    switch (Corner) {
    case 0:
        return [self getPrevX:XM
                            Y:YM];
    case 1:
        return [self getPrevX:XM
                            Y:YP];

    case 2:
        return [self getPrevX:XP
                            Y:YM];
    case 3:
        return [self getPrevX:XP
                            Y:YP];

    default:
        return nil;
    }
}

- (MKCell*)getPrevX:(NSInteger)X Y:(NSInteger)Y
{
    switch (self.boundaryType) {
    case periodicBoundaryConditions:
        if (Y >= y) {
            Y -= y;
        }
        if (X >= x) {
            X -= x;
        }
        if (Y < 0) {
            Y += y;
        }
        if (X < 0) {
            X += x;
        }

        return [[caPrev objectAtIndex:Y] objectAtIndex:X];
    case absorbingBoundaryConditions:
        if (X >= x || Y >= y || X < 0 || Y < 0) {
            return [[[MKCell alloc] init] getAllFrom:absorbingCell];
        } else {
            return [[caPrev objectAtIndex:Y % y] objectAtIndex:X % x];
        }
    default:
        break;
    }

    return nil;
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
