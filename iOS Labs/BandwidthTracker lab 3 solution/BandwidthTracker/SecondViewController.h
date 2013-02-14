//
//  SecondViewController.h
//  BandwidthTracker
//
//  Created by Mark Vitale on 12/4/12.
//  Copyright (c) 2012 Mark Vitale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface SecondViewController : UIViewController

-(IBAction)textFieldDidEndEditing:(UITextField *)textField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) KeychainItemWrapper *passwordItem;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
