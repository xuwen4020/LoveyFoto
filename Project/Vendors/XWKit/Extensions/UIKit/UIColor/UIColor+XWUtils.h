//
//  UIColor+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XWUtils)
+ (UIColor * _Nullable)xwColorWithRGB:(uint32_t)rgbValue;
+ (UIColor * _Nullable)xwColorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor * _Nullable)xwColorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (nullable UIColor *)xwColorWithHexString:(NSString * _Nonnull)hexStr;
@end
