//
//  BuyViewController.m
//  hermes-ios
//
//  Created by Tse-Chi Wang on 6/1/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import "BuyViewController.h"
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface BuyViewController () {
    double tokenValue,passValue,donateValue;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation BuyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tokenChanged:(id)sender {
UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if(segmentedControl.selectedSegmentIndex == 0){
		tokenValue = 0.00;
	}
	if(segmentedControl.selectedSegmentIndex == 1){
        tokenValue = 3.00;
	}
    if(segmentedControl.selectedSegmentIndex == 2){
        tokenValue = 13.50;
	}
    if(segmentedControl.selectedSegmentIndex == 3){
        tokenValue = 27.00;
	}
    [self updateFields];
}

- (IBAction)passChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if(segmentedControl.selectedSegmentIndex == 0){
		passValue = 0.00;
	}
	if(segmentedControl.selectedSegmentIndex == 1){
        passValue = 133.75;
	}
    [self updateFields];
}

- (IBAction)donateChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if(segmentedControl.selectedSegmentIndex == 0){
		donateValue = 0.00;
	}
	if(segmentedControl.selectedSegmentIndex == 1){
        donateValue = 3.00;
	}
    [self updateFields];
}

-(void)updateFields{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.tokenLabel.text =[numberFormatter stringFromNumber:[NSNumber numberWithDouble:tokenValue]];
    
    self.passLabel.text =[numberFormatter stringFromNumber:[NSNumber numberWithDouble:passValue]];
    
    self.donateLabel.text =[numberFormatter stringFromNumber:[NSNumber numberWithDouble:donateValue]];
    
    self.totalLabel.text =[numberFormatter stringFromNumber:[NSNumber numberWithDouble:tokenValue+passValue+donateValue]];
}

- (IBAction)payPressed:(id)sender {
    NSMutableArray *items = [[NSMutableArray alloc] init];

    NSInteger tokenIndex = self.tokenControl.selectedSegmentIndex;
    NSInteger passIndex = self.passControl.selectedSegmentIndex;
    NSInteger donateIndex = self.donateControl.selectedSegmentIndex;
    
    if(tokenIndex==0 && passIndex==0 && donateIndex==0)return;
    
    if(tokenIndex==1) {
        PayPalItem *anItem = [PayPalItem itemWithName:@"TTC Token"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"3.00"]
                                        withCurrency:@"CAD"
                                             withSku:@"TTC-00037"];
        [items addObject:anItem];
    }
    
    
    if(tokenIndex==2) {
        PayPalItem *anItem = [PayPalItem itemWithName:@"TTC Token"
                                         withQuantity:1
                                            withPrice:[NSDecimalNumber decimalNumberWithString:@"13.50"]
                                         withCurrency:@"CAD"
                                              withSku:@"TTC-00038"];
        [items addObject:anItem];
    }
    
    
    if(tokenIndex==3) {
        PayPalItem *anItem = [PayPalItem itemWithName:@"TTC Token"
                                         withQuantity:1
                                            withPrice:[NSDecimalNumber decimalNumberWithString:@"27.00"]
                                         withCurrency:@"CAD"
                                              withSku:@"TTC-00039"];
        [items addObject:anItem];
    }
    
    
    if(passIndex==1) {
        PayPalItem *anItem = [PayPalItem itemWithName:@"TTC Token"
                                         withQuantity:1
                                            withPrice:[NSDecimalNumber decimalNumberWithString:@"133.75"]
                                         withCurrency:@"CAD"
                                              withSku:@"TTC-00037"];
        [items addObject:anItem];
    }
    
    if(donateIndex==1) {
        PayPalItem *anItem = [PayPalItem itemWithName:@"TTC Token"
                                         withQuantity:1
                                            withPrice:[NSDecimalNumber decimalNumberWithString:@"3.00"]
                                         withCurrency:@"CAD"
                                              withSku:@"TTC-00037"];
        [items addObject:anItem];
    }
    
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"CAD";
    payment.shortDescription = @"TTC Hermes Purchase";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];

}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    
    NSInteger tokenIndex = self.tokenControl.selectedSegmentIndex;
    NSInteger passIndex = self.passControl.selectedSegmentIndex;
    NSInteger donateIndex = self.donateControl.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger curTokens = [defaults integerForKey:@"tokens"];
    
    
    if(tokenIndex==1) {
        [defaults setInteger:curTokens+1 forKey:@"tokens"];
    }
    
    
    if(tokenIndex==2) {
                [defaults setInteger:curTokens+5 forKey:@"tokens"];
    }
    
    
    if(tokenIndex==3) {
                [defaults setInteger:curTokens+10 forKey:@"tokens"];
    }
    
    
    if(passIndex==1) {
    }
    
    if(donateIndex==1) {
    }
    
    [defaults synchronize];

    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Payment Success"
                                                     message:@"Fares Purchased!"
                                                    delegate:self
                                           cancelButtonTitle:@"Okay"
                                           otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
       [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}
@end
