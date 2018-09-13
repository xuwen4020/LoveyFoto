//
//  BZUser.m
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZUser.h"

@implementation BZUser
SingletonM(BZUser)

- (BOOL)isVIP
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"kISVIP"];
}

- (NSInteger)clearCash
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"CLEARCASH"];
}


@end
