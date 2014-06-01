//
//  ViewController.h
//  hermes-ios
//
//  Created by Tse-Chi Wang on 5/31/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import "PayPalMobile.h"

@interface ViewController : UIViewController <EAIntroDelegate, PayPalFuturePaymentDelegate, UIPopoverControllerDelegate>
@property(nonatomic, strong, readwrite) NSString *environment;
- (IBAction)signinPressed:(id)sender;

@end
