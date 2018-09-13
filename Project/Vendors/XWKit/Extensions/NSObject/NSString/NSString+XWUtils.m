//
//  NSString+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "NSString+XWUtils.h"
#import "NSString+XWValidator.h"
#import "XWKitDefines.h"

#define kStringTransformFailMsg @"解码失败"

@implementation NSString (XWUtils)

- (NSDictionary *)xwJSONStringToDictWithResult: (XWStringUtilResultBlock)result {
    if (self.length <= 2) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        kXW_EXECUTE_BLOCK(result, NO, kStringTransformFailMsg)
        return nil;
    }
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        kXW_EXECUTE_BLOCK(result, NO, kStringTransformFailMsg)
        return nil;
    }
    return dict;
}

- (NSString *)xwStringToBase64StringWithResult: (XWStringUtilResultBlock)result {
    if ([self xwIsNull]) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        kXW_EXECUTE_BLOCK(result, NO, kStringTransformFailMsg)
        return nil;
    }
    NSString *encodedString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedString;
}

- (NSString *)xwBase64StringToStringWithResult: (XWStringUtilResultBlock)result {
    if ([self xwIsNull]) {
        return nil;
    }
    NSString *temp = self;
    temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    temp = [temp stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:temp options:0];
    if (data == nil) {
        kXW_EXECUTE_BLOCK(result, NO, kStringTransformFailMsg)
        return nil;
    }
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodedString;
}

- (UIImage *)xwBase64StringToImageWithResult:(XWStringUtilResultBlock)result {
    if ([self xwIsNull]) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (data == nil) {
        kXW_EXECUTE_BLOCK(result, NO, kStringTransformFailMsg)
        return nil;
    }
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}

- (NSString *)xwChineseToPinyin {
    if ([self xwIsNull]) {
        return nil;
    }
    NSMutableString *string = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((CFMutableStringRef)string,NULL, kCFStringTransformStripDiacritics,NO);
    return string;
}

- (NSAttributedString *)xwAddLineSpace: (CGFloat)lineSpace {
    if ([self xwIsNull]) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, [self length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

- (BOOL)xwIsContainTargetStr:(NSString *)targetStr {
    if (!targetStr) {
        return NO;
    }
    return ([self rangeOfString:targetStr].location == NSNotFound) ? NO : YES;
}

- (NSString *)xwGetTailStringWithLength:(NSInteger)length {
    if (length > self.length) {
        return @"";
    }
    return [self substringWithRange:NSMakeRange(self.length - length, length)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}
@end
