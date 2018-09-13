//
//  NSDate+JLCategories.m
//  JLKit
//
//  Created by JopiN.L on 16/3/30.
//  Copyright © 2016年 JopiN. All rights reserved.
//

#import "NSDate+JLCategories.h"
#import <ARKit/ARKit.h>

@implementation NSDate (JLCategories)
#pragma mark -
#pragma mark Public Methods

/** 今天还剩多少秒 */
+ (NSInteger)secondsTodayRemain
{
    // 获得当前系统日期
    NSDate *currentDate = [NSDate date];
    // 创建一个时间日期格式化器对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式化的样式
    formatter.dateFormat = @"HH:mm:ss";
    // 设置时区为当前系统时区
    formatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *dateStr = [formatter stringFromDate:currentDate];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@":"];
    NSInteger hour = [dateArray.firstObject integerValue];
    NSInteger minite = [dateArray[1] integerValue];
    NSInteger second = [dateArray[2] integerValue];
    
    NSInteger remain = (23-hour)*3600+(59-minite)*60+59-second;
    
    return remain;
}

/** 今日倒计时*/
+ (NSString *)stringSecondTodayRemain
{
    NSInteger secondsCountDown = [NSDate secondsTodayRemain];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

/** 盘算是否是今天*/
+ (BOOL)istoday:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [formatter dateFromString:timeStr];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"YYYY-MM-dd";
    formatter1.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *dateStr = [formatter1 stringFromDate:date];
    NSString *currentStr = [NSDate jl_currentTimeStringWithFormat:@"YYYY-MM-dd"];
    
    return [dateStr isEqualToString:currentStr];
}
/** 判断是否是这周*/
+ (BOOL)isThisWeek:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [formatter dateFromString:timeStr];
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents *comps1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *comps2 = [calendar components:unitFlags fromDate:currentDate];
    
#warning 是否是这一年还没有判断
    return [comps1 weekOfYear] == [comps2 weekOfYear];
}


+ (NSString *)getCurrentTime
{
    return [NSDate jl_currentTimeStringWithFormat:@"YYYY-MM-dd HH:mm:ss"];
}

+ (NSString *)jl_currentTimeStringWithFormat:(NSString *)format
{
    // 获得当前系统日期
    NSDate *currentDate = [NSDate date];
    // 创建一个时间日期格式化器对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式化的样式
    formatter.dateFormat = format;
    // 设置时区为当前系统时区
    formatter.timeZone = [NSTimeZone systemTimeZone];
    // 按照指定的样式和时区将NSDate对象格式化成NSString
    return [formatter stringFromDate:currentDate];
}

+ (NSString *)jl_currentTimeStringWithType:(JLDateFormat)format
{
    NSString *DateFormat = [NSString string];
    if (format == JLDateFormatLatin)
    {
        DateFormat = @"dd-MM-yyyy";
    }
    else if (format == JLDateFormatUK)
    {
        DateFormat = @"MM-dd-yyyy";
    }
    else if (format == JLDateFormatAsia)
    {
        DateFormat = @"yyyy-MM-dd";
    }
    else if (format == JLDateFormatHMS)
    {
        DateFormat = @"HH:mm:ss";
    }
    
    return [self jl_currentTimeStringWithFormat:DateFormat];
}

+ (NSInteger)jl_getCurrentTimeDetailWithType:(JLDateType)type
{
    //-- 设置成阳历  适配iOS7.0
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSInteger calendarUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    components = [calendar components:calendarUnits fromDate:[NSDate date]];
    
    NSInteger detailTime;
    
    switch (type)
    {
        case JLDateTypeYear:
            detailTime = [components year];
            break;
        case JLDateTypeMonth:
            detailTime = [components month];
            break;
        case JLDateTypeDay:
            detailTime = [components day];
            break;
        case JLDateTypeHour:
            detailTime = [components hour];
            break;
        case JLDateTypeMinute:
            detailTime = [components minute];
            break;
        case JLDateTypeSecond:
            detailTime = [components second];
            break;
        case JLDateTypeWeekDay:
        {
            //-- 这里的1代表星期天,所以需要装换
            detailTime = [components weekday];
            
            detailTime -= 1;
            
            if (detailTime == 0)
            {
                detailTime = 7;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return detailTime;
}

+ (NSString *)jl_since1970:(long long)seconds
{
    NSString *time = [[NSDate dateWithTimeIntervalSince1970:seconds] description];
    
    time = [time substringToIndex:19];
    
    return time;
}

+ (NSString *)jl_makeDateToStringWithType:(JLDateTranslateType)type date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (type == JLDateTranslateTypeYMD)
    {
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    else if (type == JLDateTranslateTypeHMS)
    {
        formatter.dateFormat = @"HH:mm:ss";
    }
    
    return [formatter stringFromDate:date];
}

+ (NSDate *)jl_makeStringToDateWithType:(JLDateTranslateType)type string:(NSString *)string
{
    NSString *timeStr = [string copy];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (type == JLDateTranslateTypeYMD)
    {
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    else if (type == JLDateTranslateTypeHMS)
    {
        formatter.dateFormat = @"HH:mm:ss";
    }
    
    return [formatter dateFromString:timeStr];
}

#pragma mark -
#pragma mark Private Methods


#pragma mark - 聊天专用
- (NSString *)chatDate{
    if([self isToday]){
        return [NSDate jl_makeDateToStringWithType:JLDateTranslateTypeHMS date:self];
    }else{
        return [NSDate jl_makeDateToStringWithType:JLDateTranslateTypeYMD date:self];
    }
}

- (BOOL)isToday
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"YYYY-MM-dd";
    formatter1.timeZone = [NSTimeZone systemTimeZone];
    NSString *dateStr = [formatter1 stringFromDate:self];
    NSString *currentStr = [NSDate jl_currentTimeStringWithFormat:@"YYYY-MM-dd"];
    return [dateStr isEqualToString:currentStr];
}

@end
