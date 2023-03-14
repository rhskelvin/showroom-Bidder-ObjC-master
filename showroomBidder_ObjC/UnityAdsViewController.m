//
//  UnityAdsViewController.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 5/12/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "UnityAdsViewController.h"
#import <UnityAds/UnityAds.h>

@interface UnityAdsViewController () <UnityAdsLoadDelegate, UnityAdsInitializationDelegate, UnityAdsShowDelegate, UADSBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *SDKVersion;
@property (strong, nonatomic) UADSBannerView *bannerView;
@property (copy, nonatomic) NSString *bannerId;

@end

@implementation UnityAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SDKVersion.text = UnityAds.getVersion;
// 3467696
    [UnityAds initialize: @"14850" testMode: false initializationDelegate: self];
    self.bannerId = @"bannerads";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38.0f/255.0f
       green:50.0f/255.0f
        blue:63.0f/255.0f
       alpha:1.0f];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    NSLog(@"%ld", (long)indexPath.section);
    if(indexPath.row == 0 && indexPath.section == 0){
        [UnityAds load: @"video" loadDelegate: self];
        [UnityAds show: self placementId: @"video" showDelegate: self];
    }
    if(indexPath.row == 0 && indexPath.section == 1){
        [UnityAds show: self placementId: @"rewardedVideo" showDelegate: self];
        [UnityAds load: @"rewardedVideo" loadDelegate: self];
    }
    if(indexPath.row == 0 && indexPath.section == 2){
        self.bannerView = [[UADSBannerView alloc] initWithPlacementId: self.bannerId size: CGSizeMake(320, 50)];
        self.bannerView.delegate = self;
        [self addBannerViewToBottomView: self.bannerView];
        [self.bannerView load];
    }
}

#pragma mark UnityAdsInitializationDelegate

- (void)initializationComplete {
    NSLog(@"UnityAds initializationComplete");
}

- (void)initializationFailed: (UnityAdsInitializationError)error
                 withMessage: (NSString *)message {
    NSLog(@"UnityAds initializationFailed: %ld - %@", (long)error, message);
}

#pragma mark UnityAdsLoadDelegate

- (void)unityAdsAdLoaded: (NSString *)placementId {
    NSLog(@"UnityAds adLoaded");
}

- (void)unityAdsAdFailedToLoad: (NSString *)placementId withError: (UnityAdsLoadError)error withMessage: (NSString *)message {
    NSLog(@"UnityAds adFailedToLoad: %ld - %@", (long)error, message);
}

#pragma mark UnityAdsShowDelegate
- (void)unityAdsShowComplete: (NSString *)placementId withFinishState: (UnityAdsShowCompletionState)state {
    NSLog(@"UnityAds showComplete %@ %ld", placementId, state);
}

- (void)unityAdsShowFailed: (NSString *)adUnitId withError: (UnityAdsShowError)error withMessage: (NSString *)message {
    NSLog(@"UnityAds showFailed %@ %ld", message, error);
}

- (void)unityAdsShowStart: (NSString *)adUnitId {
    NSLog(@"UnityAds showStart %@", adUnitId);
}

- (void)unityAdsShowClick: (NSString *)adUnitId {
    NSLog(@"UnityAds showClick %@", adUnitId);
}

#pragma mark : UADSBannerViewDelegate

- (void)bannerViewDidLoad: (UADSBannerView *)bannerView {
    // Called when the banner view object finishes loading an ad.
    NSLog(@"UnityAds Banner loaded for placement: %@", bannerView.placementId);
}

- (void)bannerViewDidClick: (UADSBannerView *)bannerView {
    // Called when the banner is clicked.
    NSLog(@"UnityAds Banner was clicked for placement: %@", bannerView.placementId);
}

- (void)bannerViewDidLeaveApplication: (UADSBannerView *)bannerView {
    // Called when the banner links out of the application.
}

- (void)bannerViewDidError: (UADSBannerView *)bannerView error: (UADSBannerError *)error {
    NSLog(@"UnityAds Banner encountered an error for placement: %@ with error message %@", bannerView.placementId, [error localizedDescription]);
}

- (void)addBannerViewToBottomView: (UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: bannerView];
    [self.view addConstraints: @[
         [NSLayoutConstraint constraintWithItem: bannerView
                                      attribute: NSLayoutAttributeBottom
                                      relatedBy: NSLayoutRelationEqual
                                         toItem: self.bottomLayoutGuide
                                      attribute: NSLayoutAttributeTop
                                     multiplier: 1
                                       constant: 0],
         [NSLayoutConstraint constraintWithItem: bannerView
                                      attribute: NSLayoutAttributeCenterX
                                      relatedBy: NSLayoutRelationEqual
                                         toItem: self.view
                                      attribute: NSLayoutAttributeCenterX
                                     multiplier: 1
                                       constant: 0]
    ]];
}
@end
