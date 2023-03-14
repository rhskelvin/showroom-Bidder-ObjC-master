//
//  ViewController.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 4/28/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "ViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBAnalytics.h>
#import <Chartboost/CHBInterstitial.h>
#import <Chartboost/CHBRewarded.h>
#import <AppLovinSDK/AppLovinSDK.h>
#import <UnityAds/UnityAds.h>


@interface ViewController() <CHBInterstitialDelegate, CHBRewardedDelegate, CHBBannerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UnityAdsLoadDelegate, UnityAdsInitializationDelegate, UnityAdsShowDelegate, MAAdDelegate, MARewardedAdDelegate, MAAdViewAdDelegate>
{NSArray *_pickerData;
    NSArray *_imageData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, strong) CHBInterstitial *CBinterstitial;
@property (nonatomic, strong) CHBRewarded *CBrewarded;
@property (nonatomic, strong) MAInterstitialAd *interstitialAd;
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@end

@implementation ViewController

//Chartboost-IV
- (void)CB_loadInterstitialAd
{
    [self.CBinterstitial cache];
}

- (void)CB_loadRewardedVideo
{
    [self.CBrewarded cache];
}

//MAX-IV
- (void)createInterstitialAd
{
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

//MAX-RV
- (void)createRewardedAd
{
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @"1639ab8324d5e168"];
    self.rewardedAd.delegate = self;

    // Load the first ad
    [self.rewardedAd loadAd];
}

- (void)showRewardedAd {
    [self.rewardedAd showAd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Unity Init
    [UnityAds initialize : @"14850" testMode : false];

    //MAX Loading
    [self createInterstitialAd];
    [self createRewardedAd];

    //Chartboost Loading
    self.CBinterstitial = [[CHBInterstitial alloc] initWithLocation:CBLocationDefault delegate:self];
    [self CB_loadInterstitialAd];

    self.CBrewarded = [[CHBRewarded alloc] initWithLocation:CBLocationDefault delegate:self];
    [self CB_loadRewardedVideo];
    // Initialize Data
    _pickerData = @[@"MAX", @"UnityAds", @"Chartboost"];
    _imageData = @[[UIImage imageNamed:@"applovin.png"],[UIImage imageNamed:@"unityads.png"],[UIImage imageNamed:@"chartboost3.png"]];
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

//MAX
- (IBAction)MAX_showInterstitialAdsButton:(id)sender {
    // Optional: Assign delegates
    [self showInterstitialAd];

    [self createInterstitialAd];
}

- (IBAction)MAX_showRewardedVideoAdsButton:(id)sender {
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
- (IBAction)UA_showInterstitialAdsButton:(id)sender {
    [UnityAds load: @"video" loadDelegate: self];
    [UnityAds show: self placementId: @"video" showDelegate: self];
}
- (IBAction)UA_showRewardedVideoButton:(id)sender {
    [UnityAds show: self placementId: @"rewardedVideo" showDelegate: self];
    [UnityAds load: @"rewardedVideo" loadDelegate: self];
}
- (IBAction)CB_showInterstitialAdsButton:(id)sender {
    [self.CBinterstitial showFromViewController:self];
    [self CB_loadInterstitialAd];
}
- (IBAction)CB_showRewardedVideoButton:(id)sender {
    if (self.CBrewarded.isCached) {
        [self.CBrewarded showFromViewController:self];
    } else {
        NSLog(@"Chartboost: No Rewarded Video");
        [self CB_loadRewardedVideo];
    }
}


// MARK: - CHBAdDelegate

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error {
    NSLog(@"Chartboost: Did Cache Ads");
    //[self log:[NSString stringWithFormat:@"didCacheAd: %@ %@", [event.ad class], [self statusWithError:error]]];
}

- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error {
    NSLog(@"Chartboost: Did Show Ads");
    //[self log:[NSString stringWithFormat:@"didShowAd: %@ %@", [event.ad class], [self statusWithError:error]]];
}

- (BOOL)shouldConfirmClick:(CHBClickEvent *)event confirmationHandler:(void(^)(BOOL))confirmationHandler {
    NSLog(@"Chartboost: Show Confirm Click");
    //[self log:[NSString stringWithFormat:@"shouldConfirmClick: %@", [event.ad class]]];
    return NO;
}

- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    NSLog(@"Chartboost: Did CLick Ad");
    //[self log:[NSString stringWithFormat:@"didClickAd: %@ %@", [event.ad class], [self statusWithError:error]]];
}

- (void)didFinishHandlingClick:(CHBClickEvent *)event error:(nullable CHBClickError *)error {
    NSLog(@"Chartboost: Finish handling Click");
    //[self log:[NSString stringWithFormat:@"didFinishHandlingClick: %@ %@", [event.ad class], [self statusWithError:error]]];
}

- (NSString *)statusWithError:(id)error
{
    return error ? [NSString stringWithFormat:@"FAILED (%@)", error] : @"SUCCESS";
}

// MARK: - CHBInterstitialDelegate

- (void)didDismissAd:(CHBDismissEvent *)event {
    NSLog(@"Chartboost: Did Dismiss Ad");
    //[self log:[NSString stringWithFormat:@"didDismissAd: %@", [event.ad class]]];
}

// MARK: - CHBRewardedDelegate

- (void)didEarnReward:(CHBRewardEvent *)event {
    NSLog(@"Chartboost: Did Earn Rewarded");
    // [self log:[NSString stringWithFormat:@"didEarnReward: %ld", (long)event.reward]];
}


#pragma mark - MAAdDelegate Protocol
- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didDisplayAd:(MAAd *)ad {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
    // Rewarded ad was displayed and user should receive the reward
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


//Picker

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog( @"%@", _pickerData[row] );
    return _pickerData[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 110;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *pickerCustomView = (id)view;
    UILabel *pickerViewLabel;
    UIImageView *pickerImageView;


    if (!pickerCustomView) {
        pickerCustomView= [[UIView alloc] initWithFrame:CGRectMake(-100.0f, 0.0f,
                                                                   200.0f, 200.0f)];
        pickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-100.0f, 25.0f, 150.0f, 150.0f)];
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 0.0f,
                                                                   200.0f, 200.0f)];

        [pickerCustomView addSubview:pickerImageView];
        [pickerCustomView addSubview:pickerViewLabel];
    }

    pickerImageView.image = _imageData[row];
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    pickerViewLabel.text = _pickerData[row];
    [pickerViewLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
    //pickerView.transform = CGAffineTransformMakeScale(1, 1);
    return pickerCustomView;}

@end
