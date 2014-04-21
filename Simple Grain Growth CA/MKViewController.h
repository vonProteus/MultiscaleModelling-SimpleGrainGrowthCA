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

@property (retain, nonatomic, readwrite) IBOutlet NSTextField* tfInfo;
@property (retain, nonatomic, readwrite) IBOutlet NSTextField* tfDislocationSize;
@property (retain, nonatomic, readwrite) IBOutlet NSTextField* tfGrainIdsToSave;
@property (retain, nonatomic, readwrite) IBOutlet NSTextField* tfNumberOfGrainToCreate;

- (IBAction)andrzej:(id)sender;
- (IBAction)andrzejToEnd:(id)sender;
- (IBAction)newGrain:(id)sender;
- (IBAction)addToSave:(id)sender;
- (IBAction)newDislocationCircle:(id)sender;
- (IBAction)newDislocationSquare:(id)sender;
- (IBAction)newRandomDislocation:(id)sender;
- (IBAction)newRandomGrain:(id)sender;
- (IBAction)cleam:(id)sender;

- (IBAction)boundaryTypeChange:(id)sender;
- (IBAction)neighborsTypeChange:(id)sender;
- (IBAction)ruleTypeChange:(id)sender;

@end
