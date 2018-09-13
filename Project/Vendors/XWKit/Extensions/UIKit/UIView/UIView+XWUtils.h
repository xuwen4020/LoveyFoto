//
//  UIView+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWUtils)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

- (void)shadowColor:(UIColor *)shadowColor opacity:(CGFloat)opacity offset:(CGSize)size radius:(CGFloat)radius;
/** 画圆角*/
- (void)xwDrawCornerWithRadiuce:(CGFloat)radiuce;
/** 绘制边框*/
- (void)xwDrawBorderWithColor:(UIColor *)color radiuce:(CGFloat)radiuce width:(CGFloat)width;

/**
 UIRectCornerTopLeft
 * UIRectCornerTopRight
 * UIRectCornerBottomLeft
 * UIRectCornerBottomRight
 * UIRectCornerAllCorners
 */
- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce;

/** 底部划线*/
- (void)showBottomLineWithXSpace:(CGFloat)xSpace;
- (void)showBottomLineWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace;
/** 顶部划线*/
- (void)showTopLineWithXSpace:(CGFloat)xSpace;
- (void)showTopLineWithHeight:(CGFloat)height;
@end
