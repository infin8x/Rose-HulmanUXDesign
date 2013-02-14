//
//  SecondViewController.m
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize passwordItem;
@synthesize  usernameTextField, passwordTextField;
@synthesize pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)findAndResignFirstResponder{
	for (UIView *aView in [self.view subviews]){
		if ([aView isFirstResponder] ) {
			[aView resignFirstResponder];
		}
	}
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	for (UITouch *touch in touches){
		if (touch.view == self.view){
			[self findAndResignFirstResponder];
		}
	}
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewWillAppear:(BOOL)animated
{
    
    [usernameTextField setText:[self getUserName]];
    
    [passwordTextField setText:[self getPassword]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    // Store username to keychain
    if ([usernameTextField text])
    {
        [self setUserName:[usernameTextField text]];
    }
    
    // Store password to keychain
    if ([passwordTextField text])
    {
        [self setPassword:[passwordTextField text]];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void) setUserName:(NSString *)username
{
    [self loadPasswordItem];
    
    [passwordItem setObject:username forKey:(__bridge id)kSecAttrAccount];
}

- (void) setPassword:(NSString *)password
{
    [self loadPasswordItem];
    
    [passwordItem setObject:password forKey:(__bridge id)kSecValueData];
}

- (void) loadPasswordItem
{
    if(passwordItem == nil)
    {
        passwordItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:@"422ME6PATL.edu.rose-hulman.ScheduleLookup"];
    }
}


@end
