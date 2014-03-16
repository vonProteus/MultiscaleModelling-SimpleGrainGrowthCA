//
//  MKAutomat.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKCell.h"
#import "MKEnums.h"

@interface MKAutomat : NSObject {
    NSInteger x, y, lastId;
    NSArray* ca;
    NSArray* caPrev;
    enum BoundaryTypes boundaryType;
    enum NeighborsTypes neighborsType;
    MKCell* absorbingCell;
}

@property (readonly) NSInteger x, y, lastId;
@property (readwrite) enum BoundaryTypes boundaryType;
@property (readwrite) enum NeighborsTypes neighborsType;

- (id)init;
- (id)initWithX:(NSInteger)X Y:(NSInteger)Y;

- (NSInteger)andrzej;
- (MKCell*)getX:(NSInteger)X Y:(NSInteger)Y;

- (NSInteger)addNewGrainAtX:(NSInteger)X Y:(NSInteger)Y;
- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithR:(NSInteger)R;
- (bool)addNewDislocationAtX:(NSInteger)X Y:(NSInteger)Y WithD:(NSInteger)D;
@end
