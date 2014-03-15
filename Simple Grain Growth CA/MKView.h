//
//  MKView.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MKView;

@protocol MKViewDelegate
- (void)mouseClickAt:(NSPoint)p;
@end

@interface MKView : NSView
@property (nonatomic, assign) id delegate;

@end
