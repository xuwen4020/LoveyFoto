//
//  NSDate+JLCategories.h
//  JLKit
//
//  Created by JopiN.L on 16/3/30.
//  Copyright © 2016年 JopiN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JLDateFormat)
{
    JLDateFormatAsia = 0,  //yyyy-MM-dd 年月日
    JLDateFormatUK,        //MM-dd-yyyy 月日年
    JLDateFormatLatin,     //dd-MM-yyyy 年月日
    JLDateFormatHMS
};

typedef NS_ENUM(NSInteger, JLDateType)
{
    JLDateTypeYear = 0,
    JLDateTypeMonth,
    JLDateTypeDay,
    JLDateTypeHour,
    JLDateTypeMinute,
    JLDateTypeSecond,
    JLDateTypeWeekDay
};

typedef NS_ENUM(NSInteger, JLDateTranslateType)
{
    JLDateTranslateTypeYMD      =0,
    JLDateTranslateTypeHMS
};

@interface NSDate (JLCategories)

/** 今天还剩多少秒 */
+ (NSInteger)secondsTodayRemain;

/** 今日倒计时*/
+ (NSString *)stringSecondTodayRemain;

/** 盘算是否是今天*/
+ (BOOL)istoday:(NSString *)timeStr;

/** 判断是否是这周*/
+ (BOOL)isThisWeek:(NSString *)timeStr;

/** 返回当前日期:默认格式 YYYY-MM-dd HH:mm:ss*/
+ (NSString *)getCurrentTime;

/** 按格式返回当前日期*/
+ (NSString *)jl_currentTimeStringWithFormat:(NSString *)format;

/** 按格式返回当前日期*/
+ (NSString *)jl_currentTimeStringWithType:(JLDateFormat)format;

/** 获取年/月/日/小时/分钟/秒/星期*/
+ (NSInteger)jl_getCurrentTimeDetailWithType:(JLDateType)type;

/** 根据距离1970年的秒数算出当前日期*/
+ (NSString *)jl_since1970:(long long)seconds;

/** 将date转换成string*/
+ (NSString *)jl_makeDateToStringWithType:(JLDateTranslateType)type date:(NSDate *)date;

/** 将string转换成date*/
+ (NSDate *)jl_makeStringToDateWithType:(JLDateTranslateType)type string:(NSString *)string;


//聊天专用返回
- (NSString *)chatDate;

@end
