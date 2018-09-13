//
//  NSString+XWFormatter.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "NSString+XWFormatter.h"
#import "NSString+XWValidator.h"
#import "XWKitDefines.h"

#define kSuccessMsg @"成功"
#define kPhoneLengthErrMsg @"手机号长度不能超过13位"
#define kPhonePureNumberErrMsg @"手机号必须是纯数字"

@implementation NSString (XWFormatter)

#pragma mark -
#pragma mark 电话号相关
- (NSString *)xwFormatToPhone {
    return [self xwFormatToPhoneWithResult:nil];
}
- (NSString *)xwFormatToPhoneWithResult:(XWNSStringFormatterResultBlock)result {
    if (self.length > 13) {
        kXW_EXECUTE_BLOCK(result, NO, kPhoneLengthErrMsg)
        return self;
    }
    NSString *tempString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![tempString xwIsPureNumber]) {
        kXW_EXECUTE_BLOCK(result, NO, kPhonePureNumberErrMsg)
        return tempString;
    }
    kXW_EXECUTE_BLOCK(result, YES, kSuccessMsg)
    return [tempString toPhoneFormat];
}
- (NSString *)xwFormatToSecurePhone {
    if (self.length != 11) {
        return self;
    }
    NSString *pre3 = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *suf4 = [self substringWithRange:NSMakeRange(7, 4)];
    return [[pre3 stringByAppendingString:[@"****" stringByAppendingString:suf4]] toPhoneFormat];
}
- (NSString *)toPhoneFormat {
    NSString *tempString = self;
    NSUInteger length = tempString.length;
    if (length > 3 && length <= 7) {
        NSString *pre3 = [tempString substringWithRange:NSMakeRange(0, 3)];
        pre3 = [pre3 stringByAppendingString:@" "];
        NSString *center4 = [tempString substringWithRange:NSMakeRange(3, length - 3)];
        return [pre3 stringByAppendingString:center4];
    }
    if (length > 7) {
        NSString *pre3 = [tempString substringWithRange:NSMakeRange(0, 3)];
        pre3 = [pre3 stringByAppendingString:@" "];
        NSString *center4 = [tempString substringWithRange:NSMakeRange(3, 4)];
        center4 = [center4 stringByAppendingString:@" "];
        NSString *suf4 = [tempString substringWithRange:NSMakeRange(7, length - 7)];
        return [pre3 stringByAppendingString:[center4 stringByAppendingString:suf4]];
    }
    return tempString;
}

#pragma mark -
#pragma mark 银行卡号相关
- (NSString *)xwFormatToSecureBankNumber {
    NSUInteger length = self.length;
    if (length < 4) {
        return self;
    }
    NSString *suf4 = [self substringWithRange:NSMakeRange(length - 4, 4)];
    return [@"**** **** **** " stringByAppendingString:suf4];
}

#pragma mark -
#pragma mark 金额相关
- (NSString *)xwFormatToMoney {
    NSUInteger length = self.length;
    if (length <= 3) {
        return self;
    }
    if (length <= 6) {
        NSString *pre = [self substringWithRange:NSMakeRange(0, length - 3)];
        NSString *suf = [self substringWithRange:NSMakeRange(length - 3, 3)];
        return [[pre stringByAppendingString:@","] stringByAppendingString:suf];
    }
    if (length <= 9) {
        NSString *pre = [self substringWithRange:NSMakeRange(0, length - 6)];
        NSString *center = [self substringWithRange:NSMakeRange(length - 6, 3)];
        NSString *suf = [self substringWithRange:NSMakeRange(length - 3, 3)];
        return [[[[pre stringByAppendingString:@","] stringByAppendingString:center] stringByAppendingString:@","] stringByAppendingString:suf];
    }
    return self;
}

@end
