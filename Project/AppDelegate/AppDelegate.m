//
//  AppDelegate.m
//  Project
//
//  Created by xuwen on 2018/4/16.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate+BZDataConfig.h"
#import "AppDelegate+BZAnalysis.h"



@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * manager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self dataConfig];
    [self appStart];
    [self analysis:application Options:launchOptions];
    return YES;
}


#pragma mark -appstart
- (void)appStart
{
    [self appearanceConfiger];
    [self customModuleConfiger];
    [self keyboardManagerConfiger];
}

- (void)appearanceConfiger {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"nav_fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : Font(18)};
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //tab 背景色
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_fill"]];
}

- (void)customModuleConfiger {
//    [[AppCore sharedAppCore] regist];
//    [[TLNetBussiness sharedTLNetBussiness] boot];
}

- (void)keyboardManagerConfiger {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void) locationConfiger {
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager requestWhenInUseAuthorization];
    [_manager startUpdatingLocation];
}


@end
