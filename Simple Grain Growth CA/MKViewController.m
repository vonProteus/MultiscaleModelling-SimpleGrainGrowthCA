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
    self.automat.transitionRules = Rules1_4;

    NSInteger numberOfGrainOnStart = 15;
    NSInteger numberOfDislocationOnStart = 5;
    NSInteger maxROfDislocation = 10;
    NSInteger maxDOfDislocation = 10;

    //    numberOfGrainOnStart = 2;
    //    numberOfDislocationOnStart = 0;
    //    maxROfDislocation = 10;
    //    maxDOfDislocation = 10;

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

    [self.automat clear:nil];
    self.automat.transitionRules = Montecarlo;
        self.automat.boundaryType  = periodicBoundaryConditions;
    
    for (NSInteger x = 0; x < self.automat.x; ++x) {
        for (NSInteger y = 0; y < self.automat.y; ++y) {
            [self.automat addNewGrainAtX:x
                                       Y:y];
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
- (IBAction)newDislocationCircle:(id)sender
{
    self.status = addDislocationCircle;
}
- (IBAction)newDislocationSquare:(id)sender
{
    self.status = addDislocationSquare;
}
- (IBAction)cleam:(id)sender
{
    NSMutableSet* toSave = nil;

    if ([[self.tfGrainIdsToSave stringValue] length] > 0) {
        NSArray* splitId = [[self.tfGrainIdsToSave stringValue] componentsSeparatedByString:@", "];
        toSave = [NSMutableSet set];
        for (NSString* s in splitId) {
            [toSave addObject:[NSNumber numberWithInteger:[s integerValue]]];
        }
    }

    [self.automat clear:toSave];
    [self.view showAutomat:self.automat];
}

- (IBAction)newRandomDislocation:(id)sender
{
    bool added = NO;

    while (!added) {
        NSInteger X = arc4random() % self.automat.x;
        NSInteger Y = arc4random() % self.automat.y;
        if (arc4random() % 2 == 0) {
            added = [self.automat addNewDislocationAtX:X
                                                     Y:Y
                                                 WithR:self.tfDislocationSize.intValue];
        } else {
            added = [self.automat addNewDislocationAtX:X
                                                     Y:Y
                                                 WithD:self.tfDislocationSize.intValue];
        }
    }

    [self.view showAutomat:self.automat];
}

- (void)mouseClickAt:(NSPoint)p
{
    NSInteger X = (p.x / self.view.bounds.size.width) * self.automat.x;
    NSInteger Y = (p.y / self.view.bounds.size.height) * self.automat.y;
    //    DLog(@"%i %i", X, Y);

    switch (self.status) {
    case addDislocationCircle:
        [self.automat addNewDislocationAtX:X
                                         Y:Y
                                     WithR:self.tfDislocationSize.intValue];
        break;
    case addDislocationSquare:
        [self.automat addNewDislocationAtX:X
                                         Y:Y
                                     WithD:self.tfDislocationSize.intValue];
        break;
    case addGrain:
        [self.automat addNewGrainAtX:X
                                   Y:Y];
        break;
    case addToSave: {
        NSInteger idToSave = [self.automat saveGrainAtX:X
                                                      Y:Y];
        NSMutableString* grainIdsToSaveText = [NSMutableString stringWithString:[self.tfGrainIdsToSave stringValue]];
        if ([grainIdsToSaveText length] > 0) {
            [grainIdsToSaveText appendFormat:@", %li", idToSave];
        } else {
            [grainIdsToSaveText appendFormat:@"%li", idToSave];
        }
        [self.tfGrainIdsToSave setStringValue:grainIdsToSaveText];
    } break;
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

- (IBAction)boundaryTypeChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("periodicBoundaryConditions");
        self.automat.boundaryType = periodicBoundaryConditions;
        break;
    case 2:
        DLog("absorbingBoundaryConditions");
        self.automat.boundaryType = absorbingBoundaryConditions;
        break;

    default:
        break;
    }
}

- (IBAction)neighborsTypeChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("VonNeumannNeighborhood");
        self.automat.neighborsType = VonNeumannNeighborhood;
        break;
    case 2:
        DLog("MoorNeighborhood");
        self.automat.neighborsType = MoorNeighborhood;
        break;

    case 3:
        DLog("HexRandom");
        self.automat.neighborsType = HexRandom;
        break;

    case 4:
        DLog("PentaRandom");
        self.automat.neighborsType = PentaRandom;
        break;

    case 5:
        DLog("Hex1");
        self.automat.neighborsType = Hex1;
        break;

    case 6:
        DLog("Hex2");
        self.automat.neighborsType = Hex2;
        break;

    case 7:
        DLog("FurtherMoorNeighborhood");
        self.automat.neighborsType = FurtherMoorNeighborhood;
        break;

    default:
        break;
    }
}

- (IBAction)ruleTypeChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("Rules1");
        self.automat.transitionRules = Rules1;
        break;
    case 2:
        DLog("Rules1_4");
        self.automat.transitionRules = Rules1_4;
        break;

    default:
        break;
    }
}

- (IBAction)addToSave:(id)sender
{
    self.status = addToSave;
}
@end
