//
//  AppDelegate+BZAnalysis.m
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "AppDelegate+BZAnalysis.h"
#import <AppsFlyerFramework/AppsFlyerLib/AppsFlyerTracker.h>
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAppEvents.h>

@implementation AppDelegate (BZAnalysis)

#pragma mark - 统计
- (void)analysis:(UIApplication *)application Options:(NSDictionary *)launchOptions
{
    //统计
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"hZ6ZwBJWkaXUERqoFiWCSV";
    [AppsFlyerTracker sharedTracker].appleAppID = @"1434501086";//这个是 AppID
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventLogin withValues:@{ AFEventParamSuccess: @1 }];
    
    [FIRApp configure];
    [FIRAnalytics logEventWithName:kFIREventLogin
                        parameters:@{
                                     kFIRParameterItemID:@"startApp",
                                     kFIRParameterItemName:@"Login",
                                     }];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKAppEvents activateApp];
    [FBSDKAppEvents logEvent:@"Login"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    if (@available(iOS 9.0, *)) {
        [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    } else {
        // Fallback on earlier versions
    }
    return YES;
}

@end
