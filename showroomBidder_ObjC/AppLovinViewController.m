//
//  AppLovinViewController.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 5/12/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "AppLovinViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface AppLovinViewController ()<MAAdDelegate, MARewardedAdDelegate, MAAdViewAdDelegate>
@property (weak, nonatomic) IBOutlet UILabel *SDKVersion;
@property (nonatomic, strong) MAInterstitialAd *interstitialAd;
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@property (nonatomic, strong) MAAdView *adView;
@property (nonatomic, strong) NSString *aString;
@end

@implementation AppLovinViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _SDKVersion.text = [ALSdk version];
    [self theLoader];
    [self createInterstitialAd];
    [self createRewardedAd];
    // Do any additional setup after loading the view.
}

- (void)createInterstitialAd
{
    _aString = @"Interstitial";
    self.interstitialAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier: @"a4f17e7cadf9db48"];
    self.interstitialAd.delegate = self;

    // Load the first ad
    [self.interstitialAd loadAd];
}

- (void)showInterstitialAd {
    if ( [self.interstitialAd isReady] )
    {
        [self.interstitialAd showAd];
    }
}


- (void)createRewardedAd
{
    _aString = @"Rewarded";
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @"1639ab8324d5e168"];
    self.rewardedAd.delegate = self;

    // Load the first ad
    [self.rewardedAd loadAd];
}

- (void)showRewardedAd {
    [self.rewardedAd showAd];
}


- (void)createBannerAd
{
    _aString = @"Banner";
    self.adView = [[MAAdView alloc] initWithAdUnitIdentifier: @"fc496c4e15541b17"];
    self.adView.delegate = self;

    // Banner height on iPhone and iPad is 50 and 90, respectively
    CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;

    // Stretch to the width of the screen for banners to be fully functional
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat x = 0;
    CGFloat y = 0;

    self.adView.frame = CGRectMake(x, y, width, height);

    // Set background or background color for banner ads to be fully functional
    self.adView.backgroundColor = UIColor.blackColor;
    [self.view addSubview: self.adView];

    // Load the ad
    [self.adView loadAd];
}


// check which ad to load in delegates
- (void)theLoader {
    if ([_aString isEqualToString:@"Interstitial"]) {
        [self.interstitialAd loadAd];
    }
    else if ([_aString isEqualToString:@"Rewarded"]) {
        [self.rewardedAd loadAd];
    }
}


#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // Interstitial ad is ready to be shown. '[self.interstitialAd isReady]' will now return 'YES'
    // Reset retry attempt
//    self.retryAttempt = 0;
    NSLog(@"%@", [NSString stringWithFormat:@"%@ didLoadAd", _aString]);
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)errorCode
{
    NSLog:[NSString stringWithFormat:@"%@ didFailToLoadAdForAdUnitIdentifier %@ withErrorCode %ld", _aString, adUnitIdentifier, (long)errorCode];
    // Interstitial ad failed to load
    // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    
//    self.retryAttempt++;
//    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//    [self theLoader];
//    });
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog:[NSString stringWithFormat:@"%@ didDisplayAd", _aString];
}

- (void)didClickAd:(MAAd *)ad {
    NSLog:[NSString stringWithFormat:@"%@ didClickAd", _aString];
}

- (void)didHideAd:(MAAd *)ad
{
    // Interstitial ad is hidden. Pre-load the next ad
    NSLog:[NSString stringWithFormat:@"%@ didHideAd", _aString];
    NSLog(@"%@", [NSString stringWithFormat:@"Preloading next %@ ad...", _aString]);
    [self theLoader];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)errorCode
{
    NSLog:[NSString stringWithFormat:@"%@ didFailToDisplayAd withErrorCode %ld", _aString, (long)errorCode];
    // Interstitial ad failed to display. We recommend loading the next ad
    NSLog(@"%@", [NSString stringWithFormat:@"Preloading next %@ ad...", _aString]);
    [self theLoader];
}


#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {
NSLog:[NSString stringWithFormat:@"didStartRewardedVideoForAd"];
}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {
NSLog:[NSString stringWithFormat:@"didCompleteRewardedVideoForAd"];
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
NSLog:[NSString stringWithFormat:@"didRewardUserForAd"];
    // Rewarded ad was displayed and user should receive the reward
}


#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {
NSLog:[NSString stringWithFormat:@"Banner didExpandAd"];
}

- (void)didCollapseAd:(MAAd *)ad {
NSLog:[NSString stringWithFormat:@"Banner didCollapseAd"];
}


#pragma mark - Table view data source

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:14.0f/255.0f
                                                                           green:143.0f/255.0f
                                                                            blue:180.0f/255.0f
                                                                           alpha:1.0f];
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", (long)indexPath.row);
    NSLog(@"%ld", (long)indexPath.section);
    if(indexPath.row == 0 && indexPath.section == 0){
        if ([self.interstitialAd isReady])
            [self showInterstitialAd];
        else
            [self createInterstitialAd];
    }
    if(indexPath.row == 0 && indexPath.section == 1){
        if ( [self.rewardedAd isReady] )
        {
            [self showRewardedAd];
        }
        else
        {
            // No rewarded ad is currently available. Perform failover logic...
            NSLog(@"MAX: No Rewarded Ads");
            [self createRewardedAd];
        }
    }
    if(indexPath.row == 0 && indexPath.section == 2){
        [self createBannerAd];
    }
}

@end
