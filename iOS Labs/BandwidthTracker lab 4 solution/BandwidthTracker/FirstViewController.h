//
//  FirstViewController.h
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "VerticalProgressView.h"
#import "BandwidthUsageRecord.h"
#import "BandwidthScraperDelegate.h"


@interface FirstViewController : UIViewController <BandwidthScraperDelegate, ADBannerViewDelegate>
{
    VerticalProgressView *leftUsageView;
    VerticalProgressView *rightUsageView;
    
    BandwidthUsageRecord *record;

//    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (nonatomic, strong) BandwidthUsageRecord *record;

@property (nonatomic, strong) IBOutlet VerticalProgressView *leftUsageView;
@property (nonatomic, strong) IBOutlet VerticalProgressView *rightUsageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UILabel *leftLabel;
@property (nonatomic, strong) IBOutlet UILabel *rightLabel;

@property (nonatomic,assign) BOOL bannerIsVisible;
@property (nonatomic, strong) IBOutlet ADBannerView *adView;




- (IBAction)refreshData:(id)sender;

- (void)scraper:(BandwidthScraper *)scraper foundBandwidthUsageAmounts:(BandwidthUsageRecord *)usage;

@end
