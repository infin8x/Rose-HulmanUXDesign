//
//  FirstViewController.m
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import "FirstViewController.h"
#import "BandwidthScraper.h"

#define BANDWIDTH_POLICY 0
#define BANDWIDTH_ACTUAL 1

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize leftUsageView;
@synthesize rightUsageView;
@synthesize segmentedControl;
@synthesize record;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [segmentedControl addTarget:self action:@selector(updateViews:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshData:nil];
}

- (IBAction) refreshData:(id)sender {
    NSLog(@"refreshing data");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[[BandwidthScraper alloc] initWithDelegate:self] beginScraping];
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
    
    self.leftUsageView.barColor = [self barColorForUsageValue:[self.leftUsageView currentValue]];

}


- (UIColor *)barColorForUsageValue:(CGFloat)valf {
    if(valf > [self getAlertLevel]) {
        return [UIColor redColor];
    } else if(valf > [self getWarningLevel]) {
        return [UIColor yellowColor];
    } else {
        //return [UIColor greenColor];
        return [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:74.0/255.0 alpha:1.0];
    }
}


- (void)scraper:(BandwidthScraper *)scraper foundBandwidthUsageAmounts:(BandwidthUsageRecord *)usage {
    record = usage;
    [self updateViews:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (CGFloat) getMinValue {
    return 0;
}

- (CGFloat) getMaxValue {
    return 5500;
}

- (CGFloat) getCurrentPolicyDownloadValue {
    if (record != nil) {
        return [[record policyReceived] floatValue];
    }
    NSLog(@"record was nil...");
    return 0;
}

- (CGFloat) getCurrentActualDownloadValue {
    if (record != nil) {
        return [[record actualReceived] floatValue];
    }
    return 0;
}

- (CGFloat) getCurrentPolicyUploadValue {
    if (record != nil) {
        return [[record policySent] floatValue];
    }
    return 0;
}

- (CGFloat) getCurrentActualUploadValue {
    if (record != nil) {
        return [[record actualSent] floatValue];
    }
    return 0;
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
