//
//  UIFont+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIFont+XWUtils.h"

@implementation UIFont (XWUtils)
/** 计算对应字号的单个中文字宽度*/
- (CGFloat)xwSingleChineseTextWidth
{
    CGFloat width = 0;
    width = [@"本" sizeWithAttributes : @{NSFontAttributeName: self}].width;
    return width;
}
/** 计算对应字号单行中文文本的高度*/
- (CGFloat)xwChineseTextHeight
{
    CGFloat height = 0;
    height = [@"中文文本" sizeWithAttributes : @{NSFontAttributeName: self}].height;
    return height;
}
- (CGFloat)xwSingleEnglisTextWidth
{
    CGFloat width = 0;
    width = [@"x" sizeWithAttributes : @{NSFontAttributeName: self}].width;
    return width;
}
@end
