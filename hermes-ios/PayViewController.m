//
//  PayViewController.m
//  hermes-ios
//
//  Created by Tse-Chi Wang on 5/31/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import "PayViewController.h"
#import "BuyViewController.h"

@interface PayViewController () {
    BOOL showing;
}
@end

@implementation PayViewController
NSDate *paidDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showing=NO;
	// Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    self.navigationController.navigationBarHidden = NO;

    self.tokensLabel.text = @"0";
    paidDate = [NSDate date];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBuy)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)viewWillAppear:(BOOL)animated {
    showing = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"tokens"] == NULL) {
        [defaults setInteger:0 forKey:@"tokens"];
        [defaults synchronize];
    }
    else {
        self.tokensLabel.text = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"tokens"]];
    }
    
    if([defaults objectForKey:@"timeLabel"] != NULL) {
        self.receiptLabel.text = @"View Current Reciept";
    }
}

-(void)pushBuy{
    BuyViewController *secondView=[[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    [self.navigationController pushViewController:secondView animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"282F191E-D981-48EA-A887-3E27A7D12316"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.devfright.myRegion"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    NSLog(@"%ld",(long)beacon.rssi);
    if (beacon.rssi>-32 && beacon.rssi< -10) {
        [self eatToken];
    }
}

- (void)eatToken {
    if(showing==NO) {
    if(abs([paidDate timeIntervalSinceDate:[NSDate date]]) > 1) {
        paidDate = [NSDate date];

              [self performSegueWithIdentifier:@"ticketSegue" sender:self];
        showing =YES;
    }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetBeacon:(id)sender {
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];

}
@end
