//
//  UIView+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIView+XWUtils.h"
#import <objc/runtime.h>

static const void *XWBottomLineKey = &XWBottomLineKey;

@implementation UIView (XWUtils)

- (void)shadowColor:(UIColor *)shadowColor opacity:(CGFloat)opacity offset:(CGSize)size radius:(CGFloat)radius
{
    self.backgroundColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = size;
    self.layer.shadowRadius = radius;
    self.layer.cornerRadius = radius;
}

- (void)showBottomLineWithXSpace:(CGFloat)xSpace {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor projectBackGroudColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(xSpace);
    }];
    [self setCustomBottomLine:line];
}

- (void)showBottomLineWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor xwColorWithHexString:@"#DFE1E6"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(leftSpace);
        make.right.equalTo(self).offset(rightSpace);
    }];
    [self setCustomBottomLine:line];
}

- (void)showTopLineWithXSpace:(CGFloat)xSpace
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor projectBackGroudColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.mas_offset(@1.);
        make.left.equalTo(self).offset(xSpace);
    }];
    [self setCustomBottomLine:line];
}
- (void)showTopLineWithHeight:(CGFloat)height
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor projectBackGroudColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.equalTo(@(height));
        make.left.equalTo(self).offset(0);
    }];
    [self setCustomBottomLine:line];
}

- (void)setCustomBottomLine:(UIView *)customBottomLine{
    objc_setAssociatedObject(self, XWBottomLineKey, customBottomLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 画圆角*/
- (void)xwDrawCornerWithRadiuce:(CGFloat)radiuce
{
    [self xwDrawBorderWithColor:[UIColor clearColor] radiuce:radiuce width:1.0f];
}

//某几个边写圆角
- (void)xwDrawbyRoundingCorners:(UIRectCorner)corners withRadiuce:(CGFloat)radiuce
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radiuce, radiuce)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/** 绘制边框*/
- (void)xwDrawBorderWithColor:(UIColor *)color radiuce:(CGFloat)radiuce width:(CGFloat)width
{
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radiuce;
    self.layer.masksToBounds = YES;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
    
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
