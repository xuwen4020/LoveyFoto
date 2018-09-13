//
//  XWUserManager.h
//  Project
//
//  Created by xuwen on 2018/7/26.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWUser.h"
#import "CityAndCountryList.h"
@interface XWUserManager : NSObject
SingletonH(XWUserManager)

//设置用户信息
- (void)setUserInfo;

- (BOOL)saveEmail:(NSString *)email;
- (BOOL)savePassword:(NSString *)password;


//保存真实名字
- (BOOL)saveRealName:(NSString *)realname;
//保存城市
- (BOOL)saveCity:(NSString *)city;
//保存介绍信息
- (BOOL)saveIntroduction:(NSString *)introduction;
//保存头像
- (BOOL)saveHeadImageWithImage:(UIImage *)image;
//保存职业
- (BOOL)saveCareer:(NSString *)career;
//保存语言
- (BOOL)saveLanguage:(NSString *)language;
//保存经验
- (BOOL)saveExperience:(NSString *)experience;
//保存年龄
- (BOOL)saveAge:(int)age;
//保存性别
- (BOOL)saveGender:(int)gender;


//自动登录
- (BOOL)autoLogin;
- (void)setAutoLogon:(BOOL)isAutoLogin;

@end
