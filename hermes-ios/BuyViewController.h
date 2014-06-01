//
//  BuyViewController.h
//  hermes-ios
//
//  Created by Tse-Chi Wang on 6/1/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface BuyViewController : UIViewController<PayPalPaymentDelegate,UIAlertViewDelegate>
- (IBAction)tokenChanged:(id)sender;
- (IBAction)passChanged:(id)sender;
- (IBAction)donateChanged:(id)sender;
- (IBAction)payPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *tokenLabel;
@property (strong, nonatomic) IBOutlet UILabel *passLabel;
@property (strong, nonatomic) IBOutlet UILabel *donateLabel;
@property(nonatomic, strong, readwrite) NSString *environment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tokenControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *passControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *donateControl;

@end
