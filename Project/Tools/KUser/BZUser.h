//
//  BZUser.h
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kISVIP =  @"kISVIP";

@interface BZUser : NSObject

#define kUser [BZUser sharedBZUser]

SingletonH(BZUser)
@property (nonatomic,assign) BOOL isApple;
@property (nonatomic,assign) BOOL isVIP;

//内购 S3
@property (nonatomic,assign) BOOL showPurplePage; //展示内购页面的方式

@property (nonatomic,assign) BOOL showWeekPurchase; //紫色页面展示 week购买
@property (nonatomic,assign) BOOL yearPurchaseShowDetail;//紫色页面展示 year 详情

@property (nonatomic,assign) BOOL showblackweekPurchase; //白色页面展示购买
@property (nonatomic,assign) BOOL canClose;  //用户状态下,是否可以关闭内购; ❎
@property (nonatomic,assign) BOOL reviewing; //苹果是否在审核,给苹果大爷专门准备的 内购显示套餐;

//内购价格
@property (nonatomic,assign) float weekPrice;
@property (nonatomic,assign) float yearPrice;

//清楚缓存标识,获取到的数据和当前不同,强制清楚缓存
@property (nonatomic,assign) NSInteger clearCash;

@end
