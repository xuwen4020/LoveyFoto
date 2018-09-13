//
//  BZDoublePhoneHelper.m
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZDoublePhoneHelper.h"
#import "XWBrowserView.h"
#import "QSPDownloadTool.h"

@interface BZDoublePhoneCell()

@end


@implementation BZDoublePhoneHelper

- (instancetype)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count/2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    BZDoublePhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBZDoublePhoneCellIdentifier forIndexPath:indexPath];
    cell.showTime = self.showTimeEffect;
    [cell.leftImageview sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row*2].staticImageStr] placeholderImage:XWImageName(@"placeholder")];
    [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row*2+1].staticImageStr] placeholderImage:XWImageName(@"placeholder")];
    
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
    return 0.0000001;
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
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BZDoublePhoneCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentPage = indexPath.row;
    //进入 VIP
    if(!kUser.isVIP && indexPath.row >= 4){
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil];
    }
    
    //前后 cell 暂停下载
    if(indexPath.row<self.dataArray.count/2-1)
    {
        //后面
        NSString *videoleftStr = self.dataArray[(indexPath.row+1)*2].dynamicVedioStr;
        NSString *videorightStr = self.dataArray[(indexPath.row+1)*2+1].dynamicVedioStr;
        NSString *leftfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videoleftStr ];
        NSString *rightfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videorightStr];
        for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
            if([source.fileName isEqualToString:leftfileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
            if([source.fileName isEqualToString:rightfileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
        }
    }
    
    if(indexPath.row > 0){
       //前面
        NSString *videoleftStr = self.dataArray[(indexPath.row-1)*2].dynamicVedioStr;
        NSString *videorightStr = self.dataArray[(indexPath.row-1)*2+1].dynamicVedioStr;
        NSString *leftfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videoleftStr ];
        NSString *rightfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:videorightStr];
        for(QSPDownloadSource *source in [QSPDownloadTool shareInstance].downloadSources){
            if([source.fileName isEqualToString:leftfileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
            if([source.fileName isEqualToString:rightfileName]){
                [[QSPDownloadTool shareInstance]suspendDownload:source];
                NSLog(@"暂停任务⏸%@",source.fileName);
            }
        }
    }
    
    //出现 Cell 当前 cell
    LCPPlayerDataModel * leftModel = self.dataArray[indexPath.row*2];
    LCPPlayerDataModel * rightModel = self.dataArray[indexPath.row*2+1];
    NSString *leftVideoStr = leftModel.dynamicVedioStr;
    NSString *rightVideoStr = rightModel.dynamicVedioStr;
    [cell loadVidioWithName:leftVideoStr name:rightVideoStr];
    cell.leftfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:leftVideoStr];
    cell.rightfileName = [[QSPDownloadTool shareInstance]nameWithURLStr:rightVideoStr];
    cell.canPlay = YES;
    self.currentDoubleCell = cell;
    
    
    //前后暂停下载
    
    
}

//消失
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(BZDoublePhoneCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //消失 cell
    cell.canPlay = NO;
    [cell removePlayer];
}

- (void)setShowTimeEffect:(BOOL)showTimeEffect
{
    _showTimeEffect = showTimeEffect;
    [self.collectionView reloadData];
}

@end
