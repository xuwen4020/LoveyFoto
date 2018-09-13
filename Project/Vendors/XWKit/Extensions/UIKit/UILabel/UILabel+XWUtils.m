//
//  UILabel+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UILabel+XWUtils.h"

@implementation UILabel (XWUtils)
- (void)commonLabelConfigWithTextColor:(UIColor *)textColor font:(UIFont *)font aliment:(NSTextAlignment)aliment {
    self.textColor = textColor;
    self.font = font;
    self.textAlignment = aliment;
}

@end
