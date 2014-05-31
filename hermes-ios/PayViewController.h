//
//  PayViewController.h
//  hermes-ios
//
//  Created by Tse-Chi Wang on 5/31/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PayViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *stationLabel;
@property (strong, nonatomic) IBOutlet UILabel *tokensLabel;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
