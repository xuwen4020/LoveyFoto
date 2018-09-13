//
//  UIFont+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (XWUtils)
/** 计算对应字号的单个中文字宽度*/
- (CGFloat)xwSingleChineseTextWidth;
/** 计算对应字号单行中文文本的高度*/
- (CGFloat)xwChineseTextHeight;
/** 计算对应字号的单个英文字宽度*/
- (CGFloat)xwSingleEnglisTextWidth;
@end
