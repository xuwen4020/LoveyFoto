//
//  XWVirtualUserManager.h
//  Project
//
//  Created by xuwen on 2018/7/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWVirtualUser.h"

@interface XWVirtualUserManager : NSObject
SingletonH(XWVirtualUserManager)
//获取虚拟用户
- (NSArray *)setVirtuarlUser;
//获取一个虚拟用户
- (XWVirtualUser *)getOneVirtuarlUser;
//个数
- (NSArray *)getVirturaUserCount:(int)count;

@end
