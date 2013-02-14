//
//  FirstViewController.h
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalProgressView.h"

@interface FirstViewController : UIViewController
{
    VerticalProgressView * _leftUsageView;
    VerticalProgressView * _rightUsageView;
    
}

@property (nonatomic, strong) IBOutlet VerticalProgressView *leftUsageView;
@property (nonatomic, strong) IBOutlet VerticalProgressView *rightUsageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UILabel *leftLabel;
@property (nonatomic, strong) IBOutlet UILabel *rightLabel;
@end
