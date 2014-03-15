//
//  MKAutomat.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MKCell.h"
#include "MKEnums.h"

@interface MKAutomat : NSObject {
    NSInteger x, y;
    NSArray* ca;
    NSArray* caPrev;
    enum BoundaryTypes boundaryType;
    enum NeighborsTypes neighborsType;
}

@property (readonly) NSInteger x, y;
@property (readwrite) enum BoundaryTypes boundaryType;
@property (readwrite) enum NeighborsTypes neighborsType;

- (id)init;
- (id)initWithX:(NSInteger)X Y:(NSInteger)Y;

- (void)andrzej;
- (NSSet*)getAllNeighborsForX:(NSInteger)X andY:(NSInteger)Y;
@end
