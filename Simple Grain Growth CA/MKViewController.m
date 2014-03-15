//
//  MKViewController.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKViewController.h"
#include "MKAutomat.h"
#include "MKCell.h"

@interface MKViewController ()
@property (retain, nonatomic, readwrite) MKAutomat* automat;
@property (readwrite) enum ViewStatus status;
@end

@implementation MKViewController

- (void)awakeFromNib
{
    DLog("start");
    self.view.delegate = self;
    self.automat = [[MKAutomat alloc] init];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)andrzej:(id)sender
{
    [self.automat andrzej];
    [self.view showAutomat:self.automat];
}

- (IBAction)andrzejToEnd:(id)sender
{
    while ([self.automat andrzej] > 0) {
    }
}
- (IBAction)newGrain:(id)sender
{
    self.status = addGrain;
}
- (IBAction)newDislocation:(id)sender
{
    self.status = addDislocation;
}
- (IBAction)cleam:(id)sender
{
    self.automat = [[MKAutomat alloc] init];
}

- (void)mouseClickAt:(NSPoint)p
{
    NSInteger X = (p.x / self.view.bounds.size.width) * self.automat.x;
    NSInteger Y = (p.y / self.view.bounds.size.height) * self.automat.y;
    DLog(@"%i %i", X, Y);

    switch (self.status) {
    case addDislocation:
        [self.automat addNewDislocationAtX:X
                                         Y:Y
                                     WithR:10];
        break;
    case addGrain:
        [self.automat addNewGrainAtX:X
                                   Y:Y];
        break;
    default:
        break;
    }

    self.status = doNothingView;
}

@end
