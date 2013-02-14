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
@synthesize bannerIsVisible;
@synthesize adView;

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
//    VerticalProgressView *newLeftUsageView = [[VerticalProgressView alloc] initWithFrame:leftUsageView.frame];
//    VerticalProgressView *newRightUsageView = [[VerticalProgressView alloc] initWithFrame:rightUsageView.frame];
//
//    [newLeftUsageView setMinValue:[self getMinValue]];
//    [newLeftUsageView setMaxValue:[self getMaxValue]];
//    [newLeftUsageView addLabelAt:[self getWarningLevel]];
//    [newLeftUsageView addLabelAt:[self getAlertLevel]];
//    
//    [newRightUsageView setMinValue:[self getMinValue]];
//    [newRightUsageView setMaxValue:[self getMaxValue]];
//    [newRightUsageView addLabelAt:[self getWarningLevel]];
//    [newRightUsageView addLabelAt:[self getAlertLevel]];

    [self.leftUsageView setMinValue:[self getMinValue]];
    [self.leftUsageView setMaxValue:[self getMaxValue]];
    [self.leftUsageView addLabelAt:[self getWarningLevel]];
    [self.leftUsageView addLabelAt:[self getAlertLevel]];
    
    [self.rightUsageView setMinValue:[self getMinValue]];
    [self.rightUsageView setMaxValue:[self getMaxValue]];
    [self.rightUsageView addLabelAt:[self getWarningLevel]];
    [self.rightUsageView addLabelAt:[self getAlertLevel]];

    if(segmentedControl.selectedSegmentIndex == BANDWIDTH_POLICY){
//        [newLeftUsageView setCurrentValue:[self getCurrentPolicyDownloadValue]];
//        [newRightUsageView setCurrentValue:[self getCurrentPolicyUploadValue]];
        [leftUsageView setCurrentValue:[self getCurrentPolicyDownloadValue]];
        [rightUsageView setCurrentValue:[self getCurrentPolicyUploadValue]];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentPolicyDownloadValue]];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentPolicyUploadValue]];
    } else if(segmentedControl.selectedSegmentIndex == BANDWIDTH_ACTUAL){
//        [newLeftUsageView setCurrentValue:[self getCurrentActualDownloadValue]];
//        [newRightUsageView setCurrentValue:[self getCurrentActualUploadValue]];
        [leftUsageView setCurrentValue:[self getCurrentActualDownloadValue]];
        [rightUsageView setCurrentValue:[self getCurrentActualUploadValue]];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentActualDownloadValue]];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f MB", [self getCurrentActualUploadValue]];
    }
//    newLeftUsageView.barColor = [self barColorForUsageValue:[newLeftUsageView currentValue]];
//    newRightUsageView.barColor = [self barColorForUsageValue:[newRightUsageView currentValue]];
    leftUsageView.barColor = [self barColorForUsageValue:[leftUsageView currentValue]];
    rightUsageView.barColor = [self barColorForUsageValue:[rightUsageView currentValue]];
    
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
    return 11000;
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
    return 8000;
}

- (CGFloat) getAlertLevel {
    return 9000;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
