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
        DLog("init");
        colors = [NSMutableArray array];
        toDraw = [NSMutableArray array];
        [toDraw addObject:[NSMutableArray array]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    DLog("draw");
    [super drawRect:dirtyRect];

    //    if ([self inLiveResize]) {
    //        // Draw a quick approximation
    //    } else {
    //        // Draw with full detail

    NSGraphicsContext* gc = [NSGraphicsContext currentContext];

    [gc saveGraphicsState];

    NSRect obszar, okno;
    okno = [self bounds];

    obszar.size.width = okno.size.width / toDraw.count;
    obszar.size.height = okno.size.height / ((NSArray*)[toDraw objectAtIndex:0]).count;

    for (NSInteger a = 0; a < toDraw.count; ++a) {
        NSArray* line = [toDraw objectAtIndex:0];
        for (NSInteger b = 0; b < line.count; ++b) {
            obszar.origin.x = a * obszar.size.width;
            obszar.origin.y = b * obszar.size.height;

            //[[NSColor blackColor] setStroke];
            [[line objectAtIndex:b] setFill];

            //[[NSColor redColor] setFill];

            NSBezierPath* circlePath = [NSBezierPath bezierPath];
            //[circlePath appendBezierPathWithRect: obszar];
            [circlePath appendBezierPathWithOvalInRect:obszar];
            //[circlePath stroke];
            [circlePath fill];
        }
    }

    [gc restoreGraphicsState];
    //    }
}

- (void)mouseDown:(NSEvent*)theEvent
{
    NSPoint point = [theEvent locationInWindow];

    [_delegate mouseClickAt:point];

    DLog(@"%f %f", point.x, point.y);
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)showAutomat:(MKAutomat*)automat
{
    if (automat.lastId + 2 >= colors.count) {
        while (automat.lastId + 2 > colors.count) {
            [self addColor];
        }
    } else {
        [colors removeAllObjects];
        [self addColorR:1
                      G:1
                      B:1
                      A:1];
        [self addColorR:1
                      G:1
                      B:1
                      A:0];
        [self showAutomat:automat];
        return;
    }
    [toDraw removeAllObjects];

    for (NSInteger Y = 0; Y < automat.y; ++Y) {
        NSMutableArray* line = [NSMutableArray array];
        for (NSInteger X = 0; X < automat.x; ++X) {
            [line addObject:[colors objectAtIndex:[automat getX:X
                                                              Y:Y].grainId + 1]];
        }
        [toDraw addObject:line];
    }

    [self needsDisplay];
}

- (void)addColor
{
    [self addColorR:(arc4random() % 255)
                  G:(arc4random() % 255)
                  B:(arc4random() % 255)
                  A:1];
}
- (void)addColorR:(CGFloat)R
                G:(CGFloat)G
                B:(CGFloat)B
                A:(CGFloat)A
{
    [colors addObject:[NSColor colorWithDeviceRed:R / 255.0
                                            green:G / 255.0
                                             blue:B / 255.0
                                            alpha:A]];
}
@end
