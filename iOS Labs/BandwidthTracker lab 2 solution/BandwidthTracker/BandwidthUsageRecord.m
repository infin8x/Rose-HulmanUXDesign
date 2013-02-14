//
//  BandwidthUsageRecord.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/27/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "BandwidthUsageRecord.h"

NSInteger dateIdentifier(NSInteger year, NSInteger month, NSInteger day) {
    return 1000000 * year + 1000 * month + day;
}

@implementation BandwidthUsageRecord



@synthesize kerberosName;
@synthesize timestamp;
@synthesize policyReceived;
@synthesize policySent;
@synthesize actualReceived;
@synthesize actualSent;
@synthesize bandwidthClass;



@end
