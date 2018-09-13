//
//  NSMutableDictionary+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "NSMutableDictionary+XWUtils.h"

@implementation NSMutableDictionary (XWUtils)
/** 字典转json字符串*/
- (NSString *)xwDictToJSON
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
@end
