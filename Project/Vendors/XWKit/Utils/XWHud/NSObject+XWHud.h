//
//  NSObject+XWHud.h
//  Project
//
//  Created by xuwen on 2018/5/2.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(void);

@interface NSObject (XWHud)
/** 提示HUD*/
- (void)showHint:(NSString *)hint;
/** 菊花HUD*/
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;
/** 隐藏HUD*/
- (void)hideHud;
/** 提示HUD*/
- (void)showHint:(NSString *)hint withYoff:(float)yOff;

//展示时间
- (void)showHudInView:(UIView *)view afterTime:(NSInteger)second complete:(CompleteBlock)complete;
- (void)showHudInView:(UIView *)view afterTime:(NSInteger)second hit:(NSString *)hint complete:(CompleteBlock)complete;
@end
