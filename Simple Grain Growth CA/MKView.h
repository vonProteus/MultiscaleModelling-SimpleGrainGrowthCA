//
//  MKView.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKCell.h"
#import "MKAutomat.h"

@class MKView;

@protocol MKViewDelegate
- (void)mouseClickAt:(NSPoint)p;
@end

@interface MKView : NSView {
    NSMutableArray* colors;
    NSMutableArray* toDraw;
    enum ViewType viewType;
}
@property (nonatomic, assign) id delegate;
@property (readwrite) enum ViewType viewType;

- (void)showAutomat:(MKAutomat*)automat;

- (void)mouseWasClickedAtCalback:(void (^)(NSPoint))calback;

@end
