//
//  ChartboostViewController.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 5/7/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "ChartboostViewController.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBAnalytics.h>
#import <Chartboost/CHBInterstitial.h>
#import <Chartboost/CHBRewarded.h>

@interface ChartboostViewController () <CHBInterstitialDelegate, CHBRewardedDelegate, CHBBannerDelegate>


@property (nonatomic, strong) CHBInterstitial *CBinterstitial;
@property (nonatomic, strong) CHBRewarded *CBrewarded;
@property (weak, nonatomic) IBOutlet UILabel *SDK_version;
@property (weak, nonatomic) IBOutlet UITableViewCell *didCacheAdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *willShowAdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *didShowAdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *shouldConfirmClickCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *didClickAdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *didFinishHandlingClickCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *didDismissAdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *didEarnRewardCell;
@property (weak, nonatomic) IBOutlet UILabel *InterstitialLocation;
@property (weak, nonatomic) IBOutlet UILabel *RewardedVideoLocation;
@property (weak, nonatomic) IBOutlet UILabel *BannerLocation;
@property (nonatomic, strong) CHBBanner *banner;

@end

@implementation ChartboostViewController

//Chartboost-IV
- (void)CB_loadInterstitialAd
{
    [self.CBinterstitial cache];
    
}

- (void)CB_loadRewardedVideo
{
    [self.CBrewarded cache];
}

- (void)CB_loadBannerAd {
    if (!self.banner.superview) {
        [self layoutBanner];
    }
    [self.banner showFromViewController:self];
}

- (void)layoutBanner {
    [self.view addSubview:self.banner];
    self.banner.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutAnchor *bottomContainerAnchor = self.view.bottomAnchor;
    if (@available(iOS 11.0, *)) {
        bottomContainerAnchor = self.view.safeAreaLayoutGuide.bottomAnchor;
    }
    [NSLayoutConstraint activateConstraints:@[[self.banner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [self.banner.bottomAnchor constraintEqualToAnchor:bottomContainerAnchor]]];
}


- (void)resetStatus
{
    _willShowAdCell.accessoryType = UITableViewCellAccessoryNone;
    _didShowAdCell.accessoryType = UITableViewCellAccessoryNone;
    _shouldConfirmClickCell.accessoryType = UITableViewCellAccessoryNone;
    _didClickAdCell.accessoryType = UITableViewCellAccessoryNone;
    _didFinishHandlingClickCell.accessoryType = UITableViewCellAccessoryNone;
    _didDismissAdCell.accessoryType = UITableViewCellAccessoryNone;
    _didEarnRewardCell.accessoryType = UITableViewCellAccessoryNone;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.SDK_version.text = Chartboost.getSDKVersion;
    //self.debugDESC.text = Chartboost.debugDescription;
    NSLog(@"%@", Chartboost.debugDescription);
    _InterstitialLocation.text = CBLocationDefault;
    self.CBinterstitial = [[CHBInterstitial alloc] initWithLocation:CBLocationDefault delegate:self];
    [self CB_loadInterstitialAd];

    self.CBrewarded = [[CHBRewarded alloc] initWithLocation:CBLocationDefault delegate:self];
    _RewardedVideoLocation.text = CBLocationDefault;
    [self CB_loadRewardedVideo];
    
    self.banner = [[CHBBanner alloc] initWithSize:CHBBannerSizeStandard location:CBLocationDefault delegate:self];
    _BannerLocation.text = CBLocationDefault;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    NSLog(@"%ld", (long)indexPath.section);
    if(indexPath.row == 0 && indexPath.section == 0){
        [self.CBinterstitial showFromViewController:self];
        [self resetStatus];
    }
    if(indexPath.row == 0 && indexPath.section == 1){
            if (self.CBrewarded.isCached) {
            [self.CBrewarded showFromViewController:self];
        } else {
            NSLog(@"Chartboost: No Rewarded Video");
            
        }
      [self resetStatus];
    }
    if(indexPath.row == 0 && indexPath.section == 2){
        [self CB_loadBannerAd];
        [self resetStatus];
    }
}

- (void)log:(NSString *)message
{
    NSLog(@"%@", message);
    //self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, message];
}
// MARK: - CHBAdDelegate

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    [self log:[NSString stringWithFormat:@"didCacheAd: %@ %@", [event.ad class], [self statusWithError:error]]];
    _didCacheAdCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)willShowAd:(CHBShowEvent *)event {
    [self log:[NSString stringWithFormat:@"willShowAd: %@", [event.ad class]]];
    _willShowAdCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error {
    [self log:[NSString stringWithFormat:@"didShowAd: %@ %@", [event.ad class], [self statusWithError:error]]];
     _didShowAdCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    [self log:[NSString stringWithFormat:@"didClickAd: %@ %@", [event.ad class], [self statusWithError:error]]];
    _didClickAdCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)didFinishHandlingClick:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    [self log:[NSString stringWithFormat:@"didFinishHandlingClick: %@ %@", [event.ad class], [self statusWithError:error]]];
    _didFinishHandlingClickCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (NSString *)statusWithError:(id)error
{
    return error ? [NSString stringWithFormat:@"FAILED (%@)", error] : @"SUCCESS";
}

// MARK: - CHBInterstitialDelegate

- (void)didDismissAd:(CHBDismissEvent *)event {
    [self log:[NSString stringWithFormat:@"didDismissAd: %@", [event.ad class]]];
    [self CB_loadInterstitialAd];
     _didDismissAdCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

// MARK: - CHBRewardedDelegate

- (void)didEarnReward:(CHBRewardEvent *)event {
    [self log:[NSString stringWithFormat:@"didEarnReward: %ld", (long)event.reward]];
    [self CB_loadRewardedVideo];
     _didEarnRewardCell.accessoryType = UITableViewCellAccessoryCheckmark;
}


@end
