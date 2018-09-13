//
//  XWCollectManager.h
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPPlayerDataModel.h"

@interface XWCollectManager : NSObject
SingletonH(XWCollectManager)

- (void)collectWithModel:(LCPPlayerDataModel *)model;
- (void)cancelCollectWithModel:(LCPPlayerDataModel *)model;
- (BOOL)isCollectWithModel:(LCPPlayerDataModel *)model;

//存储的 array
- (NSArray <LCPPlayerDataModel *>*)collectionArray;
@end

