//
//  XWUser.m
//  Project
//
//  Created by xuwen on 2018/7/26.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWUser.h"
#define kEMAIL  @"kusername"
#define kPASSWORD  @"kpassword"

@implementation XWUser
SingletonM(XWUser)

- (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kEMAIL];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kPASSWORD];
}

@end
