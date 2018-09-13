//
//  XWDownLoadData.m
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWDownLoadData.h"


@interface XWDownLoadData()<QSPDownloadToolDelegate>
@property (strong, nonatomic) NSMutableArray <QSPDownloadSource *>*dataArr;
@end

@implementation XWDownLoadData
SingletonM(XWDownLoadData)

- (QSPDownloadSource *)addDownLoadWithURLStr:(NSString *)urlStr
{
    //判断是否存在,如果存在就 retuen
    NSString *name = [[QSPDownloadTool shareInstance]nameWithURLStr:urlStr];
    for(QSPDownloadSource * source in self.dataArr){
        if([source.fileName isEqualToString:name]){
            return source;
        }
    }
    
    //加入下载
    [[QSPDownloadTool shareInstance] addDownloadToolDelegate:self];  //代理
    QSPDownloadSource *download = [[QSPDownloadTool shareInstance] addDownloadTast:urlStr andOffLine:YES];
//    download.delegate = self;
    [self.dataArr addObject:download];
    return download;
}


#pragma mark - <QSPDownloadToolDelegate>代理方法
- (void)downloadToolDidFinish:(QSPDownloadTool *)tool downloadSource:(QSPDownloadSource *)source
{
    
}

#pragma mark - setter & getter
- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
