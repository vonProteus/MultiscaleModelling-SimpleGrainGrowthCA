//
//  MKView.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKView.h"

@implementation MKView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (void)mouseDown:(NSEvent*)theEvent
{
    NSPoint point = [theEvent locationInWindow];
    DLog(@"%f %f", point.x, point.y);
}
@end
