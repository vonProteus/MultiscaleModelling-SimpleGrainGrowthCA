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

@synthesize x, y, boundaryType, neighborsType;

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
    return self;
}

- (void)andrzej
{
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

            currentCell.grainId = [[neighborsIds objectAtIndex:arc4random() % neighborsIds.count] intValue];
            currentCell.isLiving = YES;
            currentCell.isOnBorder = isOnBorder;
        }
    }

    caPrev = [ca copy];
}

- (NSSet*)getAllNeighborsForX:(NSInteger)X andY:(NSInteger)Y
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

@end
