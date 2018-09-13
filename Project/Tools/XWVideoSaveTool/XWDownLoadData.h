//
//  XWDownLoadData.h
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSPDownloadTool.h"

@interface XWDownLoadData : NSObject
SingletonH(XWDownLoadData)
- (QSPDownloadSource *)addDownLoadWithURLStr:(NSString *)urlStr;

@end
