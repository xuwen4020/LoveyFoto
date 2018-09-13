//
//  AppDelegate+BZDataConfig.m
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "AppDelegate+BZDataConfig.h"
#import "IPTest.h"
#import "BZMainViewController.h"
#import <RMStore/RMStore.h>
#define DeviceIsPAD  [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#import "BZPurchaseHelper.h"
#import "BZWelcomeViewController.h"
#import "BZCashTool.h"
#import "XWDownLoadData.h"

@implementation AppDelegate (BZDataConfig)

#pragma mark - 数据
- (void)dataConfig
{
    
    BZWelcomeViewController *vc = [[BZWelcomeViewController alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    //获取内购数据
    [self purchaseData];
    
    //IPtest
    kXWWeakSelf(weakSelf);
    [IPTest checkIp:^(BOOL isApple) {
        kUser.isApple = (!isApple||DeviceIsPAD);
        [weakSelf configVIP];
    } usingReivewFlag:YES];
}

- (void)purchaseData
{
    [[RMStore defaultStore]requestProducts:[NSSet setWithObjects:@"Weed_Subscription",@"Year_Subscription", nil] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        for(SKProduct *product in products){
            if([product.productIdentifier isEqualToString:@"Weed_Subscription"]){
                NSLog(@"%.2f",[product.price floatValue]);
                kUser.weekPrice = [product.price floatValue];
            }
            if([product.productIdentifier isEqualToString:@"Year_Subscription"]){
                NSLog(@"%.2f",[product.price floatValue]);
                kUser.yearPrice = [product.price floatValue];
            }
        }
    } failure:^(NSError *error) {
        kUser.weekPrice = 0.99;
        kUser.yearPrice = 49.99;
        [self showHint:@"Network Error"];
    }];
}

- (void)configVIP
{
    kXWWeakSelf(weakSelf);
    
    //做默认设置
    kUser.showPurplePage = YES;
    kUser.showWeekPurchase = YES;
    kUser.yearPurchaseShowDetail = YES;
    kUser.showblackweekPurchase = YES;
    kUser.canClose = NO;
    
    [LCPHTTPRequestManager getWithPathUrl:@"https://s3-us-west-2.amazonaws.com/wdapps/loveyFoto-Test.json" parameters:nil success:^(BOOL success, id JSON) {
        NSLog(@"%@",JSON);
        kUser.showPurplePage = [JSON[@"showPurplePage"]intValue];
        kUser.showWeekPurchase = [JSON[@"purplePage"][@"showWeekPurchase"]intValue];
        kUser.yearPurchaseShowDetail = [JSON[@"purplePage"][@"yearPurchaseShowDetail"]intValue];
        kUser.showblackweekPurchase = [JSON[@"whitePage"][@"showWeekPurchase"]intValue];
        if(kUser.isApple){
            kUser.showPurplePage = YES;
            kUser.showWeekPurchase = YES;
            kUser.yearPurchaseShowDetail = YES;
            kUser.showblackweekPurchase = YES;
        }
        
        kUser.canClose = [JSON[@"canClose"]intValue];
        kUser.reviewing  = [JSON[@"Reviewing"]intValue];
        
        //强制清楚缓存
        NSInteger cash = [JSON[@"clearCash"]integerValue];
        if(cash != kUser.clearCash){
            [BZCashTool clearCache:QSPDownloadTool_DownloadDataDocument_Path];
        }
        [[NSUserDefaults standardUserDefaults]setInteger:cash forKey:@"CLEARCASH"];
        
        
        [weakSelf rootWindowConfiger];
    } failure:^(BOOL failuer, NSError *error) {
        [self showHint:@"networkError"];
        [weakSelf rootWindowConfiger];
    }];
}

- (void)rootWindowConfiger {
    BZMainViewController *mainViewController = [[BZMainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *dele = (AppDelegate*)app.delegate;
    dele.window.rootViewController = nav;
    
    [[BZDataTool sharedBZDataTool]dataConfigWithBlock:^(BOOL isSuccess) {
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_UPLOAD_DATA object:nil];
    }];
}

@end
