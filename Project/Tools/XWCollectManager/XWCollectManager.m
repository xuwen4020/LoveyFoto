//
//  XWCollectManager.m
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWCollectManager.h"
#import "QSPDownloadTool.h"
#import "LCPPlayerDataModel.h"
#define XWCollectManager_Document_Path                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define XWCollectManager_SaveDocument_Path       [XWCollectManager_Document_Path stringByAppendingPathComponent:@"XWCollectManager_SaveDocument_Path"]

@interface XWCollectManager()
//@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation XWCollectManager
SingletonM(XWCollectManager)

- (NSArray <LCPPlayerDataModel *>*)collectionArray
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *array = [self dataArrayInit];
    for(NSDictionary *dict in array){
        LCPPlayerDataModel *model = [[LCPPlayerDataModel alloc]init];
        model.dynamicImageStr = dict[@"dynamicImageStr"];
        model.dynamicVedioStr = dict[@"dynamicVedioStr"];
        model.staticImageStr = dict[@"staticImageStr"];
        [mutableArray addObject:model];
    }
    return mutableArray;
}

- (void)collectWithModel:(LCPPlayerDataModel *)model
{
    //如果存在退出
    self.dataArray = [self dataArrayInit];
    for(NSDictionary *dict in self.dataArray){
        if([dict[@"staticImageStr"]isEqualToString:model.staticImageStr]){
            NSLog(@"已存在");
            return;
        }
    }
    
    NSDictionary *dict = @{
                           @"dynamicImageStr":@"dynamicImageStr",
                           @"dynamicVedioStr":model.dynamicVedioStr,
                           @"staticImageStr":model.staticImageStr
                           };
    [self.dataArray addObject:dict];
    [self saveCollectionArray];
}

- (void)cancelCollectWithModel:(LCPPlayerDataModel *)model
{
    self.dataArray = [self dataArrayInit];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
    for(NSDictionary *dict in array){
        if([dict[@"staticImageStr"]isEqualToString:model.staticImageStr]){
            [self.dataArray removeObject:dict];
            [self saveCollectionArray];
        }
    }
}

- (BOOL)isCollectWithModel:(LCPPlayerDataModel *)model
{
    BOOL flag = NO;
    self.dataArray = [self dataArrayInit];
    for(NSDictionary *dict in self.dataArray){
        if([dict[@"staticImageStr"]isEqualToString:model.staticImageStr]){
            flag = YES;
            return flag;
        }
    }
    return flag;
}

#pragma mark - private
- (void)saveCollectionArray;
{
    NSDictionary *dic = @{@"data":self.dataArray};
    if([dic writeToFile:XWCollectManager_SaveDocument_Path atomically:YES]){
        NSLog(@"写入成功");
    }else{
        NSLog(@"写入失败");
    }
    NSLog(@"%@",XWCollectManager_SaveDocument_Path);
}

- (NSMutableArray *)dataArrayInit;
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:XWCollectManager_SaveDocument_Path];
    NSArray *array = dict[@"data"];
    _dataArray = [NSMutableArray arrayWithArray:array];
    NSLog(@"收藏🌙🌙🌙%@",array);
    return _dataArray;
}

//- (NSString *)fileName
//{
//    if(!_fileName){
//        return XWCollectManager_DownloadDataDocument_Path;
//
////        NSString *plistpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
////        NSLog(@"path = %@",plistpath);
////        NSString *filename=[plistpath stringByAppendingPathComponent:@"collection.plist"];
////        _fileName = [NSString stringWithString:filename];
////        NSFileManager* fm = [NSFileManager defaultManager];
////        [fm createFileAtPath:filename contents:nil attributes:nil];
//    }
//    return _fileName;
//}

@end
