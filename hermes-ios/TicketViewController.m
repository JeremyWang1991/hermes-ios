//
//  TicketViewController.m
//  hermes-ios
//
//  Created by Tse-Chi Wang on 6/1/2014.
//  Copyright (c) 2014 Jeremy. All rights reserved.
//

#import "TicketViewController.h"
#import "AFNetworking.h"
@interface TicketViewController ()

@end

@implementation TicketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour] -12;
    NSInteger minute = [components minute];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d PM",hour,minute];
    self.expireLabel.text = [NSString stringWithFormat:@"%02d:%02d PM",hour+3,minute];
    
    NSString *string = @"http://myttc.ca/queens_park_station.json";
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if ([defaults objectForKey:@"timeLabel"] != NULL) {
        self.timeLabel.text = [defaults objectForKey:@"timeLabel"];
        self.expireLabel.text = [defaults objectForKey:@"expireLabel"];
        self.subwayLabel.text = [defaults objectForKey:@"subwayLabel"];
        return;
    }
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *times = (NSDictionary *)responseObject;
        //NSLog(@"%@",[[[[[[[times objectForKey:@"stops"] objectAtIndex:6] objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"stop_times"] objectAtIndex:0] objectForKey:@"departure_time"]);
        self.subwayLabel.text =[[[[[[[times objectForKey:@"stops"] objectAtIndex:6] objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"stop_times"] objectAtIndex:1] objectForKey:@"departure_time"];
        
        
        [defaults setObject:self.timeLabel.text forKey:@"timeLabel"];
        [defaults setObject:self.expireLabel.text forKey:@"expireLabel"];
        [defaults setObject:self.subwayLabel.text forKey:@"subwayLabel"];
        
        [defaults synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
