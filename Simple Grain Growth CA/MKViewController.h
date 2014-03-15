//
//  MKViewController.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MKView.h"

@interface MKViewController : NSViewController
@property (retain, nonatomic, readwrite) IBOutlet MKView* view;

- (IBAction)andrzej:(id)sender;
- (IBAction)andrzejToEnd:(id)sender;
- (IBAction)newGrain:(id)sender;
- (IBAction)newDislocation:(id)sender;
- (IBAction)cleam:(id)sender;

@end
