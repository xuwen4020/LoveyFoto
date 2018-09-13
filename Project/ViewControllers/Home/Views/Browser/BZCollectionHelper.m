//
//  BZCollectionHelper.m
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCollectionHelper.h"
#import "XWBrowserView.h"
#import "BZPhoneBrowerCell.h"
#import "XWBrowserView.h"
#import "XWCollectManager.h"

@interface BZCollectionHelper()<QSPDownloadSourceDelegate>
@property (nonatomic,strong) BZPhoneBrowerCell *currentCell;
@end

@implementation BZCollectionHelper

#pragma mark - Public
- (void)removeCurrentPlayer
{
    [self.currentCell removePlayer];
}

#pragma mark - 预加载
- (void)prepareVideoWithName:(NSString *)videoName
{
    NSLog(@"%@",[NSString stringWithFormat:@"prepare👩%@",videoName]);
    NSString *path = [[QSPDownloadTool shareInstance]pathWithURL:videoName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[QSPDownloadTool shareInstance] nameWithURLStr:videoName];
    if([fileManager fileExistsAtPath:path]){
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:fileName]){
            //文件已经下载完毕
            return;
        }else{
            //文件没有下载完毕
            BOOL fine = NO;
            for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
                if([source.fileName isEqualToString:fileName]){
                    //找到了
                    fine = YES;
                    if(source.style == QSPDownloadSourceStyleDown||source.style == QSPDownloadSourceStyleSuspend){
                        //继续下载
                        [[QSPDownloadTool shareInstance] continueDownload:source];
                        source.delegate = self;
                    }
                    return;
                }
            }
            //未找到
            if(fine == NO){
                NSError *error = nil;
                if([fileManager removeItemAtPath:path error:&error]){
                    [self downLoadVideoWithName:videoName];
                }else{
                    [self showHint:@"file error"];
                }
                return;
            }
        }
        
    }else{
        [self downLoadVideoWithName:videoName];
    }
}

//下载
- (void)downLoadVideoWithName:(NSString *)videoName {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //等待下载完毕后再去加载视频
        QSPDownloadSource * source = [[QSPDownloadTool shareInstance] addDownloadTast:videoName andOffLine:YES];
        source.delegate = self;
    });
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (void)downloadSource:(QSPDownloadSource *)source changedStyle:(QSPDownloadSourceStyle)style
{
    if(style == QSPDownloadSourceStyleFinished){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:source.fileName];
    }
}

- (void)downloadSource:(QSPDownloadSource *)source didWriteData:(NSData *)data totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten/(float)totalBytesExpectedToWrite;
    NSLog(@"%@⤴️⤴️⤴️⤴️⤴️⤴️⤴️⤴️%.1f%%",source.fileName,progress*100);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    BZPhoneBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBZPhoneBrowerCell forIndexPath:indexPath];
    cell.showTime = self.showTimeEffect;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].staticImageStr]];
//    [cell loadVidioWithName:@""];
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSCROLLWIDTH, kSCROLLHEIGHT);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.000001;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0000001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//出现
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BZPhoneBrowerCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //进入 VIP
    if(!kUser.isVIP && indexPath.row >= 4){
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil];
    }
    
    //出现 cell
    LCPPlayerDataModel * model = self.dataArray[indexPath.row];
    NSString *videoStr = model.dynamicVedioStr;
    [cell loadVidioWithName:videoStr];
    cell.fileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videoStr];
    cell.canPlay = YES;
    self.currentCell = cell;
    
    //取值
    self.currentImageView = cell.bgImageView;
    self.currentPage = indexPath.row;
    
    //是否收藏了
    NSArray <LCPPlayerDataModel *>*array = [[XWCollectManager sharedXWCollectManager] collectionArray];
    BOOL flag = NO;
    for(LCPPlayerDataModel *data in array){
        if([data.dynamicVedioStr isEqualToString:videoStr]){
            flag = YES;
        }
    }
    if(self.collectBlock){
        self.collectBlock(flag);
    }
    
    
    //前后 cell 做预加载
    if(indexPath.row<self.dataArray.count-1){
        NSString *nextvideoStr = self.dataArray[indexPath.row+1].dynamicVedioStr;
        [self prepareVideoWithName:nextvideoStr];
    }
    if(indexPath.row > 0){
        NSString *prevideoStr = self.dataArray[indexPath.row-1].dynamicVedioStr;
        [self prepareVideoWithName:prevideoStr];
    }
    
    //当前 cell 的前面第二个和后面第二个如果在下载中要暂停下载
    //后面两个
    if(indexPath.row<self.dataArray.count-2 &&self.dataArray.count >2){
        NSString *videoStr1 = self.dataArray[indexPath.row+2].dynamicVedioStr;
        NSString *fileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videoStr1];
        for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
            if([source.fileName isEqualToString:fileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
        }
    }
    //前面两个
    if(indexPath.row-1>0){
        NSString *videoStr2 = self.dataArray[indexPath.row-2].dynamicVedioStr;
        NSString *fileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videoStr2];
        for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
            if([source.fileName isEqualToString:fileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
        }
    }
}

//消失
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(BZPhoneBrowerCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //消失 cell
    cell.canPlay = NO;
    [cell removePlayer];
}

#pragma mark - setter & getter
- (void)setShowTimeEffect:(BOOL)showTimeEffect
{
    _showTimeEffect = showTimeEffect;
    [self.collectionView reloadData];
}
@end
