//
//  XWUser.h
//  Project
//
//  Created by xuwen on 2018/7/26.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWUser : NSObject
SingletonH(XWUser)

@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;

@property (nonatomic,strong) NSString *realname;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) UIImage *headImage;
@property (nonatomic,strong) NSString *career;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString * experience;
@property (nonatomic,assign) int gender;
@property (nonatomic,assign) int age;

@end
