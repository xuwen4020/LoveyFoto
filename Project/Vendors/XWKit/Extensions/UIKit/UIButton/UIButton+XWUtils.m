//
//  UIButton+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIButton+XWUtils.h"

@implementation UIButton (XWUtils)
- (void)commonButtonConfigWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor aliment:(UIControlContentHorizontalAlignment)aliment {
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:aliment];
}
- (void)commonHightlighted
{
    [self setBackgroundImage:XWImageName(@"buttonHightlight") forState:UIControlStateHighlighted];
    [self setBackgroundImage:XWImageName(@"buttonSelect") forState:UIControlStateNormal];
}
@end
