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
@property (readwrite) enum AddNucleonsType addNucleonsType;
@property (readwrite) NSInteger andrzejCount;

@end

@implementation MKViewController

- (void)awakeFromNib
{
    DLog("start");

    self.view.delegate = self;
    self.status = doNothingView;
    self.automat = [[MKAutomat alloc] init];

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

    //    [self.automat clear:nil];
    //    self.automat.transitionRules = Montecarlo;
    //        self.automat.boundaryType  = periodicBoundaryConditions;
    //
    //    for (NSInteger x = 0; x < self.automat.x; ++x) {
    //        for (NSInteger y = 0; y < self.automat.y; ++y) {
    //            [self.automat addNewGrainAtX:x
    //                                       Y:y];
    //        }
    //    }

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
    self.andrzejCount++;

    if (self.andrzejCount % self.tfDoEveryX.intValue == 0) {

        switch (self.addNucleonsType) {
        case _one:
            break;
        case _incrising:
            [self.tfNumberOfGrainToCreate setStringValue:[NSString stringWithFormat:@"%i", self.tfNumberOfGrainToCreate.intValue + self.tfChange.intValue]];
            [self newRandomGrain:nil];
            break;
        case _decrising:
            [self.tfNumberOfGrainToCreate setStringValue:[NSString stringWithFormat:@"%i", self.tfNumberOfGrainToCreate.intValue - self.tfChange.intValue]];
            [self newRandomGrain:nil];
            break;
        case _const:
            [self newRandomGrain:nil];
            break;

        default:
            break;
        }
    }
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
    [self doClearAutomat];
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
        [infoText appendFormat:@"Will grow: %@\n", cellTMP.willGrow ? @"YES" : @"NO"];
        [infoText appendFormat:@"Was changed: %@\n", cellTMP.wasChanged ? @"YES" : @"NO"];
        [infoText appendFormat:@"Was recristalized: %@\n", cellTMP.wasRecristalized ? @"YES" : @"NO"];
        [infoText appendFormat:@"Energy in Cell: %f\n", cellTMP.energy];
        [infoText appendFormat:@"Energy in Grain: %f\n", [self.automat energyOfGrainWithId:cellTMP.grainId]];
        [infoText appendFormat:@"Size of Grain: %li\n", [self.automat sizeOfGrainWithId:cellTMP.grainId]];
        DLog(@"%@", infoText);
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
    case 3:
        DLog("Montecarlo");
        [self doClearAutomat];
        for (NSInteger x = 0; x < self.automat.x; ++x) {
            for (NSInteger y = 0; y < self.automat.y; ++y) {
                if ([self.automat getX:x
                                     Y:y].grainId == 0) {
                    [self.automat addNewGrainAtX:x
                                               Y:y];
                }
            }
        }

        self.automat.transitionRules = Montecarlo;
        [self.view showAutomat:self.automat];
        break;

    default:
        break;
    }
}

- (IBAction)addToSave:(id)sender
{
    self.status = addToSave;
}
- (IBAction)newRandomGrain:(id)sender
{
    NSInteger X = 0;
    NSInteger Y = 0;

    NSInteger numberOfGrain = self.tfNumberOfGrainToCreate.intValue;

    CGFloat maxEnergy = [self.automat maxEnergy];
    CGFloat minEnergy = [self.automat minEnergy];
    CGFloat maxMin = maxEnergy - minEnergy;
    CGFloat energyToGo = [self.automat minEnergy];

    NSInteger maxErrors = 100;
    NSInteger errors = 0;

    NSInteger added = 0;

    for (NSInteger n = 0; n < numberOfGrain; ++n) {
        if (errors > maxErrors) {
            break;
        }
        X = arc4random() % self.automat.x;
        Y = arc4random() % self.automat.y;
        //        energyToGo = (arc4random() % 100000) / (maxMin) + minEnergy;
        energyToGo = 3 * minEnergy;

        switch (self.automat.transitionRules) {
        case Recrystalization: {
            MKCell* cell = [self.automat getX:X
                                            Y:Y];
            if (cell.grainId > 0) {

                if (cell.energy > energyToGo) {
                    [self.automat addNewGrainAtX:X
                                               Y:Y];
                    ++added;
                    errors = 0;
                    DLog("grain added at %li %li", X, Y);
                } else {
                    --n;
                    ++errors;
                }
            }

        } break;
        default: {
            if ([self.automat getX:X
                                 Y:Y].grainId == 0) {
                [self.automat addNewGrainAtX:X
                                           Y:Y];
                DLog("grain added at %li %li", X, Y);
                ++added;
                errors = 0;
            } else {
                --n;
                ++errors;
            }
        } break;
        }
    }

    DLog("grains added %li", added);
    [self.view showAutomat:self.automat];
}

- (void)doClearAutomat
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
}

- (IBAction)addEnergy:(id)sender
{
    [self.automat addEnergyForGrain:[self.tfEnergyForGrain floatValue]];
    [self.automat setTransitionRules:Recrystalization];
}

- (IBAction)viewTypeChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("Structure");
        self.view.viewType = Structure;
        break;
    case 2:
        DLog("Energy");
        self.view.viewType = Energy;
        break;
    default:
        break;
    }
    [self.view showAutomat:self.automat];
}
- (IBAction)energyDystrybutionChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("HomogenousInGrain");
        self.automat.energyDystrybution = HomogenousInGrain;
        break;
    case 2:
        DLog("Heterogenous");
        self.automat.energyDystrybution = Heterogenous;
        break;
    case 3:
        DLog("Homogenous");
        self.automat.energyDystrybution = Homogenous;
        break;
    default:
        break;
    }
}

- (IBAction)addingOfNucleonsChange:(id)sender
{
    switch ([[sender selectedCell] tag]) {
    case 1:
        DLog("1");
        self.addNucleonsType = _one;
        break;
    case 2:
        DLog("+");
        self.addNucleonsType = _incrising;
        break;
    case 3:
        DLog("-");
        self.addNucleonsType = _decrising;
        break;
    case 4:
        DLog("=");
        self.addNucleonsType = _const;
        break;
    default:
        break;
    }
}

- (IBAction)goAllTest:(id)sender
{
    NSDate* start = [NSDate date];

    self.view.delegate = self;
    self.status = doNothingView;
    self.automat = [[MKAutomat alloc] initWithX:100
                                              Y:100];

    NSInteger numberOfGrainOnStart = 15;
    NSInteger numberOfDislocationOnStart = 0;
    NSInteger maxROfDislocation = 0;
    NSInteger maxDOfDislocation = 0;

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

    self.automat.neighborsType = MoorNeighborhood;
    self.automat.transitionRules = Rules1;

    while ([self.automat andrzej] != 0) {
    }
    self.automat.energyDystrybution = Heterogenous;
    [self.automat addEnergyForGrain:50];
    [self.automat setTransitionRules:Recrystalization];

    NSInteger mcs = 300;
    while (mcs > 0) {
        if([self.automat andrzej] == 0){
            break;
        }
        
        --mcs;
    }

    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:start];
    ALog(@"%f", timeInterval);
    [self.view showAutomat:self.automat];
}
@end
