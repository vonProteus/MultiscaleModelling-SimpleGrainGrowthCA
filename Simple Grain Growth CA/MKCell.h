//
//  MKCell.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKCell : NSObject

@property (readwrite) NSInteger grainId;
@property (readwrite) BOOL isOnBorder, isLiving, willGrow, wasChanged, wasRecristalized;
@property (readwrite) NSInteger coordinateX, coordinateY;
@property (readwrite) CGFloat energy;

- (id)init;
- (MKCell*)getAllFrom:(MKCell*)hear;
- (void)clear;

@end
