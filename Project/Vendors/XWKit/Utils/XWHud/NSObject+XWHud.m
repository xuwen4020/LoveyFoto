//
//  NSObject+XWHud.m
//  Project
//
//  Created by xuwen on 2018/5/2.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "NSObject+XWHud.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>
#import <SVProgressHUD.h>
#import "SANetworkManager.h"

static const void *TCHUDKEY = &TCHUDKEY;

@implementation NSObject (XWHud)
- (void)showHint:(NSString *)hint{
    if ([hint isKindOfClass:[NSNull class]] || !hint || [hint xwIsNull]) {
        return;
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 180.0+kSafeAreaBottomHeight;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

/** 提示HUD*/
- (void)showHint:(NSString *)hint withYoff:(float)yOff
{
    if ([hint isKindOfClass:[NSNull class]] || !hint || [hint xwIsNull]) {
        return;
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = yOff;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, TCHUDKEY);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, TCHUDKEY, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    if (hint) {
        if (hint.length > 0) {
            [SVProgressHUD showWithStatus:hint maskType:SVProgressHUDMaskTypeBlack];
        } else {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        }
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)hideHud {
    [SVProgressHUD dismiss];
    [SVProgressHUD resetOffsetFromCenter];
}

- (void)showHudInView:(UIView *)view afterTime:(NSInteger)second complete:(CompleteBlock)complete
{
    CHECKNETWORKING
    [self showHudInView:view hint:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHud];
        if(complete){
            complete();
        }
    });
}

- (void)showHudInView:(UIView *)view afterTime:(NSInteger)second hit:(NSString *)hint complete:(CompleteBlock)complete
{
    CHECKNETWORKING
    [self showHudInView:view hint:hint];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHud];
        if(complete){
            complete();
        }
    });
}

@end
