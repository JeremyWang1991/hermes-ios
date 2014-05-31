//
//  PayViewController.m
//  hermes-ios
//
//  Created by Tse-Chi Wang on 5/31/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()
@end

@implementation PayViewController
NSDate *paidDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    self.tokensLabel.text = @"5";
    paidDate = [NSDate date];
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
    
    if (beacon.rssi>-34) {
        [self eatToken];
    }
}

- (void)eatToken {
    if(abs([paidDate timeIntervalSinceDate:[NSDate date]]) > 10) {
        paidDate = [NSDate date];
        int tokensRemaining = [self.tokensLabel.text intValue]-1;
        self.tokensLabel.text = [NSString stringWithFormat:@"%d",tokensRemaining];
        self.view.backgroundColor = [UIColor greenColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
