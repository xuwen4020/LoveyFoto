//
//  NSString+XWFormatter.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^XWNSStringFormatterResultBlock)(BOOL isSuccess, NSString *errMsg);

@interface NSString (XWFormatter)
#pragma mark -
#pragma mark 电话号相关
/** 设置为XXX XXXX XXXX格式*/
- (NSString *)xwFormatToPhone;
/** 设置为XXX XXXX XXXX格式,有结果回调*/
- (NSString *)xwFormatToPhoneWithResult: (XWNSStringFormatterResultBlock)result;
/** 设置为XXX **** XXXX格式*/
- (NSString *)xwFormatToSecurePhone;

#pragma mark -
#pragma mark 银行卡号相关
/** 设置为**** **** **** XXXX格式*/
- (NSString *)xwFormatToSecureBankNumber;

#pragma mark -
#pragma mark 金额相关
/** 设置为 100,000,000 格式*/
- (NSString *)xwFormatToMoney;
@end
