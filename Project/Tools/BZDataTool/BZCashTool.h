//
//  BZCashTool.h
//  Project
//
//  Created by xuwen on 2018/9/5.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZCashTool : NSObject
//计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path;
//计算目录大小
+(float)folderSizeAtPath:(NSString *)path;
//其那里缓存文件
+(void)clearCache:(NSString *)path;
@end
