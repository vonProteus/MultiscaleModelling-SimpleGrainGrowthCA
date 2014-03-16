//
//  MKViewController.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKViewController.h"
#import "MKAutomat.h"
#import "MKCell.h"
#import "MKEnums.h"
#import <stdlib.h>

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

    //    self.automat.boundaryType = absorbingBoundaryConditions;

    NSInteger numberOfGrainOnStart = 15;
    NSInteger numberOfDislocationOnStart = 5;
    NSInteger maxROfDislocation = 10;
    NSInteger maxDOfDislocation = 10;

    NSInteger X = 0;
    NSInteger Y = 0;

    for (NSInteger n = 0; n < numberOfGrainOnStart; ++n) {
        X = arc4random() % self.automat.x;
        Y = arc4random() % self.automat.y;
        [self.automat addNewGrainAtX:X
                                   Y:Y];
    }

    NSInteger DR = 0;
    for (NSInteger n = 0; n < numberOfDislocationOnStart; ++n) {
        X = arc4random() % self.automat.x;
        Y = arc4random() % self.automat.y;

        if (arc4random() % 2 == 0) {
            DR = arc4random() % maxDOfDislocation;

            [self.automat addNewDislocationAtX:X
                                             Y:Y
                                         WithD:DR];
        } else {
            DR = arc4random() % maxROfDislocation;

            [self.automat addNewDislocationAtX:X
                                             Y:Y
                                         WithR:DR];
        }
    }

    [self.view showAutomat:self.automat];
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
    [self.view showAutomat:self.automat];
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
    [self.view showAutomat:self.automat];
}

- (void)mouseClickAt:(NSPoint)p
{
    NSInteger X = (p.x / self.view.bounds.size.width) * self.automat.x;
    NSInteger Y = (p.y / self.view.bounds.size.height) * self.automat.y;
    //    DLog(@"%i %i", X, Y);

    switch (self.status) {
    case addDislocation:
        [self.automat addNewDislocationAtX:X
                                         Y:Y
                                     WithR:1];
        break;
    case addGrain:
        [self.automat addNewGrainAtX:X
                                   Y:Y];
        break;
    default: {
        MKCell* cellTMP = [self.automat getX:X
                                           Y:Y];
        NSMutableString* infoText = [NSMutableString string];
        [infoText appendString:@"Info:\n"];
        [infoText appendFormat:@"X: %li Y: %li\n", X, Y];
        [infoText appendFormat:@"GrainID: %li\n", cellTMP.grainId];
        [infoText appendFormat:@"Living: %@\n", cellTMP.isLiving ? @"YES" : @"NO"];
        [infoText appendFormat:@"On border: %@\n", cellTMP.isOnBorder ? @"YES" : @"NO"];
        [self.tfInfo setStringValue:infoText];
        break;
    }
    }

    [self.view showAutomat:self.automat];

    self.status = doNothingView;
}

@end
