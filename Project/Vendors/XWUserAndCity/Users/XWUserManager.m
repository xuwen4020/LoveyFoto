//
//  XWUserManager.m
//  Project
//
//  Created by xuwen on 2018/7/26.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWUserManager.h"

#define kEMAIL  @"kusername"
#define kPASSWORD  @"kpassword"

#define kREALNAME  @"krealname"
#define kHEADIMAGE @"kheadImage"
#define kCITY      @"kcity"
#define kINTRODUCTION     @"kwords"
#define kAGE       @"kage"
#define kGENDER    @"kgender"
#define kCAREER    @"career"
#define kLANGUAGE  @"language"
#define kEXPERIENCE @"experience"

#define kAUTOLOGIN @"autoLogin"

@implementation XWUserManager
SingletonM(XWUserManager)

- (void)setUserInfo
{
    XWUser *user = [XWUser sharedXWUser];
    user.email = [[NSUserDefaults standardUserDefaults]objectForKey:kEMAIL];
    user.password = [[NSUserDefaults standardUserDefaults]objectForKey:kPASSWORD];
    
    user.headImage = [self headImage];
    user.realname = [self realName];
    user.city = [self city];
    user.introduction = [self introduction];
    
    user.career = [self career];
    user.language = [self language];
    user.experience = [self experience];
    
    user.age = [self age];
    user.gender = [self gender];
}

#pragma mark - 获取信息

- (UIImage *)headImage
{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [dirArray firstObject];
    path = [path stringByAppendingPathComponent:kHEADIMAGE];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSData *picData = [NSData dataWithContentsOfFile:path];
        [XWUser sharedXWUser].headImage = [UIImage imageWithData:picData];
        return [UIImage imageWithData:picData];
    }
    return nil;
}

- (NSString *)realName
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kREALNAME];
}

- (NSString *)city
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kCITY];
}

- (NSString *)introduction
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kINTRODUCTION];
}
- (NSString *)career
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kCAREER];
}
- (NSString *)language
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kLANGUAGE];
}
- (int)age
{
    return (int)[[NSUserDefaults standardUserDefaults]integerForKey:kAGE];
}
- (int)gender
{
    return (int)[[NSUserDefaults standardUserDefaults]integerForKey:kGENDER];
}
- (NSString *)experience
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kEXPERIENCE];
}

#pragma mark - save

- (BOOL)saveEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults]setObject:email forKey:kEMAIL];
    return YES;
}

- (BOOL)savePassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:kPASSWORD];
    return YES;
}

//保存真实名字
- (BOOL)saveRealName:(NSString *)realname
{
    [[NSUserDefaults standardUserDefaults]setObject:realname forKey:kREALNAME];
    [XWUser sharedXWUser].realname = realname;
    return YES;
}
//保存城市
- (BOOL)saveCity:(NSString *)city
{
    [XWUser sharedXWUser].city = city;
    [[NSUserDefaults standardUserDefaults]setObject:city forKey:kCITY];
    return YES;
}
//保存介绍信息
- (BOOL)saveIntroduction:(NSString *)introduction
{
    [XWUser sharedXWUser].introduction = introduction;
    [[NSUserDefaults standardUserDefaults]setObject:introduction forKey:kINTRODUCTION];
    return YES;
}
//保存头像
- (BOOL)saveHeadImageWithImage:(UIImage *)image
{
    NSData *imageData =UIImageJPEGRepresentation(image,0.7);
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [dirArray firstObject];
    path = [path stringByAppendingPathComponent:kHEADIMAGE];
    [XWUser sharedXWUser].headImage = image;
    return [imageData writeToFile:path atomically:YES];
}
//保存职业
- (BOOL)saveCareer:(NSString *)career
{
    [XWUser sharedXWUser].career = career;
    [[NSUserDefaults standardUserDefaults]setObject:career forKey:kCAREER];
    return YES;
}
//保存语言
- (BOOL)saveLanguage:(NSString *)language
{
    [XWUser sharedXWUser].language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:kLANGUAGE];
    return YES;
}
//保存经验
- (BOOL)saveExperience:(NSString *)experience
{
    [XWUser sharedXWUser].experience = experience;
     [[NSUserDefaults standardUserDefaults]setObject:experience forKey:kEXPERIENCE];
    return YES;
}
//保存年龄
- (BOOL)saveAge:(int)age
{
    [XWUser sharedXWUser].age = age;
    [[NSUserDefaults standardUserDefaults]setInteger:age forKey:kAGE];
    return YES;
}
//保存性别
- (BOOL)saveGender:(int)gender
{
    [XWUser sharedXWUser].gender = gender;
    [[NSUserDefaults standardUserDefaults]setInteger:gender forKey:kGENDER];
    return YES;
}


//设置自动登录
- (BOOL)autoLogin
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:kAUTOLOGIN];
}
- (void)setAutoLogon:(BOOL)isAutoLogin
{
    [[NSUserDefaults standardUserDefaults]setBool:isAutoLogin forKey:kAUTOLOGIN];
}

@end
