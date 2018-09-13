//
//  BZCashTool.m
//  Project
//
//  Created by xuwen on 2018/9/5.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCashTool.h"
#define QSPDownloadTool_Limit 1024.0

@implementation BZCashTool
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[BZCashTool fileSizeAtPath:absolutePath];
        }
        　　　　　//SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        int64_t tytes = (NSInteger)folderSize;
        NSString *result;
        double length;
        if (tytes > QSPDownloadTool_Limit) {
            length = tytes/QSPDownloadTool_Limit;
            if (length > QSPDownloadTool_Limit) {
                length /= QSPDownloadTool_Limit;
                if (length > QSPDownloadTool_Limit) {
                    length /= QSPDownloadTool_Limit;
                    if (length > QSPDownloadTool_Limit) {
                        length /= QSPDownloadTool_Limit;
                        result = [NSString stringWithFormat:@"%.2fTB", length];
                    }
                    else
                    {
                        result = [NSString stringWithFormat:@"%.2fGB", length];
                    }
                }
                else
                {
                    result = [NSString stringWithFormat:@"%.2fMB", length];
                }
            }
            else
            {
                result = [NSString stringWithFormat:@"%.2fKB", length];
            }
        }
        else
        {
            result = [NSString stringWithFormat:@"%lliB", tytes];
        }
        
        NSLog(@"%@",result);
        
        return folderSize;
    }
    return 0;
}

+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}



@end
