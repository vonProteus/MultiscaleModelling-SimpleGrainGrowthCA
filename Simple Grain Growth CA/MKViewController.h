//
//  MKViewController.h
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MKView.h"

@interface MKViewController : NSViewController <MKViewDelegate>
@property (retain, nonatomic, readwrite) IBOutlet MKView* view;

@property (retain, nonatomic, readwrite) IBOutlet NSComboBox* cbNeighborsType;
@property (retain, nonatomic, readwrite) IBOutlet NSMatrix* mxBoundaryType;
@property (retain, nonatomic, readwrite) IBOutlet NSTextField* tfInfo;

- (IBAction)andrzej:(id)sender;
- (IBAction)andrzejToEnd:(id)sender;
- (IBAction)newGrain:(id)sender;
- (IBAction)newDislocation:(id)sender;
- (IBAction)cleam:(id)sender;

- (IBAction)boundaryTypeChange:(id)sender;

@end
