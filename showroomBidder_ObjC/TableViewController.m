//
//  TableViewController.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 5/6/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "TableViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface TableViewController ()
@property (assign, nonatomic) BOOL askPermissionToUseIDFA;
@end

@implementation TableViewController{
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:142.0f/255.0f
        green:198.0f/255.0f
         blue:73.0f/255.0f
        alpha:1.0f];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Uncomment the following line to trick ATT Permission dialog.
//    if(self.askPermissionToUseIDFA) //iOS 14
        [self askPermission];
}


- (void)askPermission
{
    if (@available(iOS 14, *)) {
        if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                NSLog(@"Tracking authorization status changed: %lu", (unsigned long)status);
            }];
        } else {
            NSLog(@"Tracking authorization status: %lu", (unsigned long)[ATTrackingManager trackingAuthorizationStatus]);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
