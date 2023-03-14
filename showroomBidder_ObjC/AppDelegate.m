//
//  AppDelegate.m
//  showroomBidder_ObjC
//
//  Created by Kelvin Leung on 4/28/20.
//  Copyright © 2020 Chartboost. All rights reserved.
//

#import "AppDelegate.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import <Chartboost/Chartboost.h>
#import <UnityAds/UnityAds.h>
#import <HeliumSdk/HeliumSdk.h>
//@import GoogleMobileAds;

static BOOL isSubjectToGDPR = NO;
static BOOL gdprConsentGiven = YES;
static BOOL cCPAConsentGiven = YES;
static BOOL isSubjectToCOPPA = NO;

@interface AppDelegate ()<HeliumSdkDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Applovin
    [ALSdk shared].mediationProvider = @"max";
    [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
        // AppLovin SDK is initialized, start loading ads
    }];
    NSLog(@"Applovin SDK initialization complete");
    // Unity Initialize at ViewController
    
    // Chartboost library
    [Chartboost startWithAppId:@"5f908affa6b4db07e648a87e"
                  appSignature:@"acb4cbef075af35514c90626ed8aeae76f54361a"
                    completion:^(BOOL success) {
        // Chartboost was initialized if success is YES
        NSLog(@"Chartboost SDK Version %@", [Chartboost getSDKVersion]);
        NSLog(@"Chartboost SDK initialization complete");
    }];
    
    [[HeliumSdk sharedHelium] startWithAppId:@"5f908b50a6b4db07e648a884" andAppSignature:@"f5f01c09d092520123eee63c86a809200dd09518" delegate:self];
    [[HeliumSdk sharedHelium] setSubjectToGDPR:isSubjectToGDPR];
    if (isSubjectToGDPR)
        [[HeliumSdk sharedHelium] setUserHasGivenConsent:gdprConsentGiven];
    [[HeliumSdk sharedHelium] setSubjectToCoppa:isSubjectToCOPPA];
    [[HeliumSdk sharedHelium] setCCPAConsent:cCPAConsentGiven];
    
//    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    return YES;
}

- (void)heliumDidStartWithError:(HeliumError *)error
{
    if (error)
    {
        NSLog(@"Helium did not start due to error: %@",error);
//        [self.txtOutput addNewLine:[NSString stringWithFormat:@"Helium Failed to start with error:%ld,%@",(long)error.errorCode, error.errorDescription]];
    }
    else
    {
        NSLog(@"Helium Started Successfully");
//        [self.txtOutput addNewLine:@"Helium Started Successfully"];
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
