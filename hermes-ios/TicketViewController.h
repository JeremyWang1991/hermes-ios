//
//  TicketViewController.h
//  hermes-ios
//
//  Created by Tse-Chi Wang on 6/1/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *expireLabel;
@property (strong, nonatomic) IBOutlet UILabel *subwayLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingLabel;

@end
