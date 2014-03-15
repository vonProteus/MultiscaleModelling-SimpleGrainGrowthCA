//
//  MKViewController.m
//  Simple Grain Growth CA
//
//  Created by Maciej Krok on 2014-03-15.
//  Copyright (c) 2014 Photep. All rights reserved.
//

#import "MKViewController.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)awakeFromNib
{
    DLog("start");
    self.view.delegate = self;
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
}

- (IBAction)andrzejToEnd:(id)sender
{
}
- (IBAction)newGrain:(id)sender
{
}
- (IBAction)newDislocation:(id)sender
{
}
- (IBAction)cleam:(id)sender
{
}

- (void)mouseClickAt:(NSPoint)p
{
    DLog(@"%f %f", p.x, p.y);
}

@end
