//
//  BZPurchaseHelper.h
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZPurchaseHelper : NSObject
SingletonH(BZPurchaseHelper)

//紫色界面配置
- (NSString *)weekString;
- (NSString *)yearTopString;
- (NSString *)yearBottomString;
- (NSString *)purchaseDescpriptionSting;
//黑色界面配置
- (NSString *)blackWeekString;
- (NSString *)blackYearString;

@end
