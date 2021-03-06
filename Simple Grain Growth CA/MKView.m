//
//  MKView.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKView.h"

@implementation MKView
@synthesize viewType;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        DLog("init");
        colors = [NSMutableArray array];
        [colors removeAllObjects];
        [self addColorR:0
                      G:0
                      B:0
                      A:0];
        toDraw = [NSMutableArray array];
        [toDraw addObject:[NSMutableArray array]];
        viewType = Structure;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //    DLog("draw");
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
        NSArray* line = [toDraw objectAtIndex:a];
        for (NSInteger b = 0; b < line.count; ++b) {
            NSColor* cellColor = [line objectAtIndex:b];
            if (cellColor != nil) {
                obszar.origin.x = b * obszar.size.width;
                obszar.origin.y = a * obszar.size.height;
                obszar.size.width++;
                obszar.size.height++;
                //[[NSColor blackColor] setStroke];
                [cellColor setFill];

                //                [[NSColor redColor] setFill];

                NSBezierPath* circlePath = [NSBezierPath bezierPath];
                //[circlePath appendBezierPathWithRect: obszar];
                if (obszar.size.width < 20) {
                    [circlePath appendBezierPathWithRect:obszar];
                } else {
                    [circlePath appendBezierPathWithOvalInRect:obszar];
                }
                //[circlePath stroke];
                [circlePath fill];
                obszar.size.width--;
                obszar.size.height--;
            }
        }
    }

    [gc restoreGraphicsState];
    //    }
}

- (void)mouseDown:(NSEvent*)theEvent
{
    NSPoint point = [theEvent locationInWindow];

    [_delegate mouseClickAt:point];

    //    DLog(@"%f %f", point.x, point.y);
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)showAutomat:(MKAutomat*)automat
{

    while (automat.lastId >= colors.count) {
        [self addColor];
    }

    [toDraw removeAllObjects];

    switch (self.viewType) {
    case Structure: {
        NSColor* dislocationColor = [NSColor blackColor];

        for (NSInteger Y = 0; Y < automat.y; ++Y) {
            NSMutableArray* line = [NSMutableArray array];
            for (NSInteger X = 0; X < automat.x; ++X) {

                NSInteger grainId = [automat getX:X
                                                Y:Y].grainId;

                if (grainId == -1) {
                    [line addObject:dislocationColor];
                } else if (grainId >= 0) {
                    [line addObject:[colors objectAtIndex:grainId]];
                }

                //            DLog("%li %li %li", X, Y, [automat getX:X
                //                                                  Y:Y].grainId);
            }
            [toDraw addObject:line];
        }
    } break;
    case Energy: {
        CGFloat min = [automat minEnergy]; //120/360 1/3
        CGFloat max = [automat maxEnergy]; //240/360 2/3
        CGFloat maxMin = max - min;

        for (NSInteger Y = 0; Y < automat.y; ++Y) {
            NSMutableArray* line = [NSMutableArray array];
            for (NSInteger X = 0; X < automat.x; ++X) {

                CGFloat energy = [automat getX:X
                                             Y:Y].energy;

                CGFloat colorVal = 2.0 / 3.0;
                if (ABS(maxMin) > 0.00000001) {
                    colorVal -= ((energy - min) / (maxMin)) / 3.0;
                }

                [line addObject:[NSColor colorWithCalibratedHue:colorVal
                                                     saturation:1
                                                     brightness:1
                                                          alpha:1]];
            }
            [toDraw addObject:line];
        }

    } break;
    default:
        break;
    }

    [self setNeedsDisplay:YES];
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

- (void)mouseWasClickedAtCalback:(void (^)(NSPoint))calback
{
    NSPoint p = NSMakePoint(0, 0);
    NSMutableArray* arr = [NSMutableArray array];

    calback(p);
}
@end
