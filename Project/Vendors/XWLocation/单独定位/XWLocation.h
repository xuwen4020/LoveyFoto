//
//  XWLocation.h
//  Project
//
//  Created by xuwen on 2018/7/31.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LocationBlock)(NSDictionary *dict);
@interface XWLocation : NSObject
SingletonH(XWLocation)
- (void)locatemapWithBlock:(LocationBlock) locationBlock;
@end


/**
 * 使用方法
 * infor.plist 中定位授权信息
 * AppDelegate 中要先好定位授权
 */
