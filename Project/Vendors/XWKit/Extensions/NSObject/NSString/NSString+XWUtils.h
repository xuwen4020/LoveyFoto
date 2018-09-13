//
//  NSString+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XWStringUtilResultBlock)(BOOL isSuccess, NSString *errMsg);

@interface NSString (XWUtils)
/** 将JSON字符串转成字典*/
- (NSDictionary *)xwJSONStringToDictWithResult: (XWStringUtilResultBlock)result;
/** 字符串转Base64字符串*/
- (NSString *)xwStringToBase64StringWithResult: (XWStringUtilResultBlock)result;
/** Base64字符串转字符串*/
- (NSString *)xwBase64StringToStringWithResult: (XWStringUtilResultBlock)result;
/** Base64字符串转图片*/
- (UIImage *)xwBase64StringToImageWithResult: (XWStringUtilResultBlock)result;
/** 中文转拼音*/
- (NSString *)xwChineseToPinyin;
/** 添加行间距*/
- (NSAttributedString *)xwAddLineSpace: (CGFloat)lineSpace;
/** 是否包含字符串*/
- (BOOL)xwIsContainTargetStr:(NSString *)targetStr;
/** 取末尾n个字符*/
- (NSString *)xwGetTailStringWithLength:(NSInteger)length;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
@end
