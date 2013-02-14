//
//  FirstViewController.m
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import "FirstViewController.h"

#define BANDWIDTH_POLICY 0
#define BANDWIDTH_ACTUAL 1

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize leftUsageView;
@synthesize rightUsageView;
@synthesize segmentedControl;
@synthesize leftLabel;
@synthesize rightLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [segmentedControl addTarget:self action:@selector(updateViews:) forControlEvents:UIControlEventValueChanged];

    [self updateViews:nil];

}

- (void) updateViews:(id)sender {
    NSLog(@"Updating Views");
    [self.leftUsageView setMinValue:[self getMinValue]];
    [self.leftUsageView setMaxValue:[self getMaxValue]];
    [self.leftUsageView addLabelAt:[self getWarningLevel]];
    [self.leftUsageView addLabelAt:[self getAlertLevel]];
    
    [self.rightUsageView setMinValue:[self getMinValue]];
    [self.rightUsageView setMaxValue:[self getMaxValue]];
    [self.rightUsageView addLabelAt:[self getWarningLevel]];
    [self.rightUsageView addLabelAt:[self getAlertLevel]];
    

    if(segmentedControl.selectedSegmentIndex == BANDWIDTH_POLICY){
        [self.leftUsageView setCurrentValue:[self getCurrentPolicyDownloadValue]];
        [self.rightUsageView setCurrentValue:[self getCurrentPolicyUploadValue]];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentPolicyDownloadValue]];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentPolicyUploadValue]];

    } else if(segmentedControl.selectedSegmentIndex == BANDWIDTH_ACTUAL){
        [self.leftUsageView setCurrentValue:[self getCurrentActualDownloadValue]];
        [self.rightUsageView setCurrentValue:[self getCurrentActualUploadValue]];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentActualDownloadValue]];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentActualUploadValue]];
    }

}

/* DUMMY METHODS - we will make these return real values later! */
- (CGFloat) getMinValue {
    return 0;
}

- (CGFloat) getMaxValue {
    return 5500;
}

- (CGFloat) getCurrentPolicyDownloadValue {
    return 3200;
}

- (CGFloat) getCurrentActualDownloadValue {
    return 3900;
}

- (CGFloat) getCurrentPolicyUploadValue {
    return 600;
}

- (CGFloat) getCurrentActualUploadValue {
    return 1000;
}

- (CGFloat) getWarningLevel {
    return 4000;
}

- (CGFloat) getAlertLevel {
    return 4500;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
