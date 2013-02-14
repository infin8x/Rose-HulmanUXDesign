//
//  BandwidthScraper.m
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "BandwidthScraper.h"
#import "XPathQuery.h"
#import "BandwidthUsageRecord.h"

#define FETCH_TIMEOUT 10.0



@interface BandwidthScraper()

- (NSNumber *)numberFromMBUsageString:(NSString *)str;

@end

@implementation BandwidthScraper

@synthesize delegate = _delegate;
@synthesize passwordItem;
#pragma mark -
#pragma mark Initializer

- (id)initWithDelegate:(id<BandwidthScraperDelegate>)delegate {
    if((self = [super init])) {
        self.delegate = delegate;
        
        _data = [[NSMutableData alloc] init];
        _state = BandwidthScraperStatePrefix;
    }
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)beginScraping {
    //NSLog(@"scraper received beginScraping");
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://netreg.rose-hulman.edu/tools/networkUsage.pl"]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                              timeoutInterval:FETCH_TIMEOUT];
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_conn start];
    
    if([self.delegate respondsToSelector:@selector(scraper:didDispatchPageRequest:)]) {
        [self.delegate scraper:self didDispatchPageRequest:request];
    }
}

- (void)cancelScraping {
    //NSLog(@"scraper received cancelScraping");
    
    [_conn cancel];
    if([self.delegate respondsToSelector:@selector(scraper:encounteredError:)]) {
        NSError * err = [[NSError alloc] initWithDomain:@"canceled" code:-1 userInfo:nil];
        [self.delegate scraper:self encounteredError:err];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSLog(@"connection did receive authentication challenge");
    
    if([challenge previousFailureCount] == 0) {
//        NSString * username = @"vitalema";
//        NSString * password = [NSString stringWithFormat:@"%@%@%@",PASSWORD1,PASSWORD2,PASSWORD3];
        NSString * username = [self getUserName];
        NSString * password = [self getPassword];
        
        //NSLog(@"creating credentials with user:%@ pass:%@", username, password);
        NSURLCredential * cred = [[NSURLCredential alloc] initWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //NSLog(@"connection did cancel authentication challenge");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"connection did receive data");
    
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"connection did finish loading");
    
    if([self.delegate respondsToSelector:@selector(scraper:didFinishLoadingConnection:)]) {
        [self.delegate scraper:self didFinishLoadingConnection:connection];
    }
    
    NSArray * results = PerformHTMLXPathQuery(_data, @"//div[@class='mainContainer']/table[@class='ms-rteTable-1'][1]/tr[@class='ms-rteTableOddRow-1']/td");
    
    BandwidthUsageRecord * usage = [[BandwidthUsageRecord alloc] init];
    
    [usage setKerberosName:@"vitalema"];
    [usage setTimestamp:[NSDate date]];
    [usage setBandwidthClass:[[results objectAtIndex:0] objectForKey:@"nodeContent"]];
    [usage setPolicyReceived:[self numberFromMBUsageString:[[results objectAtIndex:1] objectForKey:@"nodeContent"]]];
    [usage setPolicySent:[self numberFromMBUsageString:[[results objectAtIndex:2] objectForKey:@"nodeContent"]]];
    [usage setActualReceived:[self numberFromMBUsageString:[[results objectAtIndex:3] objectForKey:@"nodeContent"]]];
    [usage setActualSent:[self numberFromMBUsageString:[[results objectAtIndex:4] objectForKey:@"nodeContent"]]];
    
    if([self.delegate respondsToSelector:@selector(scraper:foundBandwidthUsageAmounts:)]) {
        [self.delegate scraper:self foundBandwidthUsageAmounts:usage];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"connection did fail with error: %@",[error description]);
    
    if([self.delegate respondsToSelector:@selector(scraper:encounteredError:)]) {
        [self.delegate scraper:self encounteredError:error];
    }
}

- (NSString *) getUserName
{
    [self loadPasswordItem];
    
    return [passwordItem objectForKey:(__bridge id)kSecAttrAccount];
}

- (NSString *) getPassword
{
    [self loadPasswordItem];
    
    return [passwordItem objectForKey:(__bridge id)kSecValueData];
}

- (void) loadPasswordItem
{
    if(passwordItem == nil)
    {
        passwordItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:@"*.edu.rose-hulman.ScheduleLookup"];
    }
}

#pragma mark -
#pragma mark Helper methods

- (NSNumber *)numberFromMBUsageString:(NSString *)str {
    NSString * stripped = [[str stringByReplacingOccurrencesOfString:@" MB" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber * number = [NSDecimalNumber decimalNumberWithString:stripped];
    return number;
}



#pragma mark -
#pragma mark dealloc


@end
