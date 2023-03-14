//
//  HeliumViewController.m
//  showroomBidder_ObjC
//
//  Created by Eugene Lee on 2/9/22.
//  Copyright © 2022 Chartboost. All rights reserved.
//

#import "HeliumViewController.h"
#import <HeliumSdk/HeliumSdk.h>

static NSString *const kInterstitalPlacement = @"CB_Pro_Interstitial";
static NSString *const kRewardedPlacement = @"CB_Pro_Rewarded";
static NSString *const kBannerPlacement = @"ALBanner";

@interface HeliumViewController () <CHBHeliumInterstitialAdDelegate,CHBHeliumRewardedAdDelegate,CHBHeliumBannerAdDelegate>
//@property (weak, nonatomic) IBOutlet UITextView *txtOutput;

@property (nonatomic) id<HeliumInterstitialAd> interstitialAd;
@property (nonatomic) id<HeliumRewardedAd> rewardedAd;
@property (nonatomic) HeliumBannerView *bannerAd;
//@property (weak, nonatomic) IBOutlet UIButton *btnShowRewarded;
//@property (weak, nonatomic) IBOutlet UIButton *btnShowInter;
//@property (weak, nonatomic) IBOutlet UIButton *btnClearInter;
//@property (weak, nonatomic) IBOutlet UIButton *btnClearRewarded;
@end

@implementation HeliumViewController

- (void)viewDidLoad {
//    self.btnShowInter.enabled=NO;
//    self.btnShowRewarded.enabled=NO;
//    self.btnClearInter.enabled=NO;
//    self.btnClearRewarded.enabled=NO;
//    self.txtOutput.text=@"";

    [self startHelium];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cacheInterstitial {
  [self.interstitialAd loadAd];
}

- (IBAction)clearInterstitial:(id)sender {
    [self.interstitialAd clearLoadedAd];
//    self.btnShowInter.enabled=NO;
}

- (IBAction)showInterstitial {
  if ([self.interstitialAd readyToShow])
    [self.interstitialAd showAdWithViewController:self];
}

- (IBAction)cacheRewarded {
  [self.rewardedAd loadAd];
}

- (IBAction)showRewarded {
    [self.rewardedAd showAdWithViewController:self];
}

- (IBAction)clearRewarded:(id)sender {
    [self.rewardedAd clearLoadedAd];
//    self.btnShowRewarded.enabled=NO;
}

- (IBAction)loadBanner:(id)sender {
    if (self.bannerAd)
      [self.bannerAd loadAd];
    
    if (!self.bannerAd.superview) {
        [self layoutBanner];
    }
}

- (IBAction)showBanner:(id)sender {
    if ([self.bannerAd readyToShow]) {
        // Remember to attach the banner to your View Controller Layout.
        // Show the banner
        [self.bannerAd showAdWithViewController:self.parentViewController];
    } else {
      //when there’s no Helium Ad ready to show immediately,
      //fall through to your chosen backup behavior
    }
}

- (IBAction)clearBanner:(id)sender {
    [self.bannerAd clearLoadedAd];
    if (self.bannerAd) {
          [self.bannerAd removeFromSuperview];
    }
}

- (void) layoutBanner {
    [self.view addSubview:self.bannerAd];
    self.bannerAd.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutAnchor *bottomContainerAnchor = self.view.bottomAnchor;
    if (@available(iOS 11.0, *)) {
        bottomContainerAnchor = self.view.safeAreaLayoutGuide.bottomAnchor;
    }
    [NSLayoutConstraint activateConstraints:@[[self.bannerAd.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [self.bannerAd.bottomAnchor constraintEqualToAnchor:bottomContainerAnchor]]];
}

- (void)startHelium
{
    self.interstitialAd = [[HeliumSdk sharedHelium] interstitialAdProviderWithDelegate:self andPlacementName:kInterstitalPlacement];
    self.rewardedAd = [[HeliumSdk sharedHelium] rewardedAdProviderWithDelegate:self andPlacementName:kRewardedPlacement];
    if (self.bannerAd == nil) {
        CHBHBannerSize bannerSize = CHBHBannerSize_Standard;
        self.bannerAd = [[HeliumSdk sharedHelium] bannerProviderWithDelegate:self andPlacementName:kBannerPlacement andSize:bannerSize];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didLoadWithError:(HeliumError *)error
{
    if (error)
    {
//        self.btnShowInter.enabled=NO;
//        self.btnClearInter.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Interstital with Placement Id:%@ failed to load with error:%ld,%@",placementName,(long)error.errorCode, error.errorDescription]];
        NSLog(@"Interstital with Placement Id:%@ failed to load with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        self.btnShowInter.enabled=YES;
//        self.btnClearInter.enabled=YES;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Intertitial with Placement Id:%@ didLoad",placementName]];
        NSLog(@"Intertitial with Placement Id:%@ didLoad",placementName);
    }
}
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary *)bidInfo
{
    NSLog(@"Placement:%@,%@",placementName,bidInfo);
}
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didShowWithError:(HeliumError *)error
{
    if (error)
    {
//        self.btnShowInter.enabled=NO;
//        self.btnClearInter.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Interstital with Placement Id:%@ failed to show with error:%@",placementName,error.errorDescription]];
        NSLog(@"Interstital with Placement Id:%@ failed to show with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        self.btnShowInter.enabled=NO;
//        self.btnClearInter.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Intertitial with Placement Id:%@ didShow",placementName]];
        NSLog(@"Intertitial with Placement Id:%@ didSHow",placementName);
    }
}
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didCloseWithError:(HeliumError *)error
{
    if (error)
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Interstital with Placement Id:%@ failed to close with error:%@",placementName,error.errorDescription]];
        NSLog(@"Interstital with Placement Id:%@ failed to close with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Intertitial with Placement Id:%@ didClose",placementName]];
        NSLog(@"Intertitial with Placement Id:%@ didClose",placementName);
    }
}
- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didClickWithError:(HeliumError *)error
{
    if (error)
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Interstital with Placement Id:%@ failed to click with error:%@",placementName,error.errorDescription]];
        NSLog(@"Interstital with Placement Id:%@ failed to click with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Intertitial with Placement Id:%@ didClick",placementName]];
        NSLog(@"Intertitial with Placement Id:%@ didClick",placementName);
    }
}


- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didLoadWithError:(HeliumError *)error
{
    if (error)
    {
//        self.btnShowRewarded.enabled=NO;
//        self.btnClearRewarded.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ failed to load with error:%@",placementName,error.errorDescription]];
        NSLog(@"Rewarded with Placement Id:%@ failed to load with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        self.btnShowRewarded.enabled=YES;
//        self.btnClearRewarded.enabled=YES;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ didLoad",placementName]];
        NSLog(@"Rewarded with Placement Id:%@ didLoad",placementName);
    }
}
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                didLoadWinningBidWithInfo:(NSDictionary *)bidInfo
{
    NSLog(@"Placement:%@,%@",placementName,bidInfo);
}
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didShowWithError:(HeliumError *)error
{
    if (error)
    {
//        self.btnShowRewarded.enabled=NO;
//        self.btnClearRewarded.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ failed to show with error:%@",placementName,error.errorDescription]];
        NSLog(@"Rewarded with Placement Id:%@ failed to show with error:%@",placementName,error.description);
    }
    else
    {
//        self.btnShowRewarded.enabled=NO;
//        self.btnClearRewarded.enabled=NO;
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ didSHow",placementName]];
        NSLog(@"Rewarded with Placement Id:%@ didSHow",placementName);
    }
}
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didCloseWithError:(HeliumError *)error
{
    if (error)
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ failed to close with error:%@",placementName,error.errorDescription]];
        NSLog(@"Rewarded with Placement Id:%@ failed to close with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ didClose",placementName]];
        NSLog(@"Rewarded with Placement Id:%@ didClose",placementName);
    }
}
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didClickWithError:(HeliumError *)error
{
    if (error)
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ failed to click with error:%@",placementName,error.errorDescription]];
        NSLog(@"Rewarded with Placement Id:%@ failed to click with error:%@",placementName,error.errorDescription);
    }
    else
    {
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ didClick",placementName]];
        NSLog(@"Rewarded with Placement Id:%@ didClick",placementName);
    }
}
- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                                didGetReward:(NSInteger)reward {
    NSLog(@"Got Reward for RV with placementid:%@, reward: %ld",placementName,(long) reward);
//    [self.txtOutput addNewLine:[NSString stringWithFormat:@"Rewarded with Placement Id:%@ didGetReward:%ld",placementName,(long)reward]];
}

- (void)heliumBannerAdWithPlacementName:(NSString *)placementName didCloseWithError:(HeliumError *)error {
    
}
  
- (void)heliumBannerAdWithPlacementName:(NSString *)placementName didLoadWithError:(HeliumError *)error {
    if (error)
    {
        NSLog(@"Banner with Placement Id:%@ failed to load with error:%@",placementName,error.errorDescription);
    }
    else
    {
        NSLog(@"Banner with Placement Id:%@ didLoad",placementName);
    }
}
  
- (void)heliumBannerAdWithPlacementName:(NSString *)placementName didShowWithError:(HeliumError *)error {
    if (error)
    {
        NSLog(@"Banner with Placement Id:%@ failed to show with error:%@",placementName,error.errorDescription);
    }
    else
    {
        NSLog(@"Banner with Placement Id:%@ didShow",placementName);
    }
}
 
- (void)heliumBannerAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary *)bidInfo
{
    NSLog(@"Placement:%@,%@",placementName,bidInfo);
}
 
- (void)heliumBannerAdWithPlacementName:(NSString *)placementName didClickWithError:(HeliumError *)error
{
    if (error) {
        NSLog(@"Banner with Placement Id:%@ didClick with error: %@", placementName, error);
    } else {
        NSLog(@"Banner with Placement Id:%@ didClick", placementName);
    }
}

@end
