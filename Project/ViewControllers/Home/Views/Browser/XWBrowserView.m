//
//  XWBrowserView.m
//  Project
//
//  Created by xuwen on 2018/8/16.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBrowserView.h"
#import "XWCollectManager.h"
#import "BZSaveAlertView.h"
#import "XWMessageAlertView.h"
#import "XWDownLoadData.h"
#import "BZCollectionHelper.h"
#import "BZCollectionViewFlowLayout.h"
#import "BZPhoneBrowerCell.h"
#import "BZCashTool.h"
#import <Photos/Photos.h>
#import "LivePhotoMaker.h"

#define kEndFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0, kSCROLLTOP+kEDGE, kShowWidth, kFRAME_HEIGHT)

#define kStartPhone CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0-kEDGE-30, kEDGE+kStatusBarHeight-30, kShowWidth+kEDGE*2+60, kFRAME_HEIGHT+kEDGE*2+60)

#define kEndPhone CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0-kEDGE, kSCROLLTOP, kShowWidth+kEDGE*2, kFRAME_HEIGHT+kEDGE*2)

@interface XWBrowserView()<BZCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic, copy) DismissBlock dismissDlock;

//滚动图片
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BZCollectionHelper *collectionHelper;

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *effectButton;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *collectButton;

//数据
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic) NSInteger index;

@end

@implementation XWBrowserView

+ (instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index parentView:(nullable UIView *)parentView category:(nullable NSString *)category dismiss:(DismissBlock)block
{
    XWBrowserView *browser = [[XWBrowserView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    browser.backgroundColor = [UIColor xwColorWithHexString:@"#F5F7FB"];
    browser.index = index;
    browser.collectionHelper.currentPage = index;
    browser.imageView = imageView;
    browser.parentView = parentView;
    browser.dataArray = URLStrings;
//    browser.URLStrings = URLStrings;
    browser.dismissDlock = block;
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];

    //如果大于200M清理
    CGFloat size = [BZCashTool folderSizeAtPath:QSPDownloadTool_DownloadDataDocument_Path];
    size = size/1024./1204.;
    if(size >=200.0){
        [BZCashTool clearCache:QSPDownloadTool_DownloadDataDocument_Path];
    }
    
    return browser;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
       
    }
    return self;
}

- (void)baseUIConfig
{
    [self.parentView addSubview:self];
    [self addSubview:self.collectionView];
    [self addSubview:self.backButton];
    [self addSubview:self.effectButton];
    [self addSubview:self.saveButton];
    [self addSubview:self.collectButton];
}

- (void)baseConstriantsConfig
{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(kStatusBarHeight+10.0);
    }];
    [self.effectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@75);
        make.right.equalTo(self.saveButton.mas_left).offset(-40);
        make.top.equalTo(self.collectionView.mas_bottom).offset(28);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@75);
        make.centerX.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom).offset(28);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@75);
        make.left.equalTo(self.saveButton.mas_right).offset(40);
        make.top.equalTo(self.collectionView.mas_bottom).offset(28);
    }];
}

- (void)backButtonClicked:(UIButton *)sender
{
    self.dismissDlock(nil, 1);
    //退出动画效果
    if(self.collectionHelper.currentPage != self.index){
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        return;
    }
    CGRect endFrame = [self.imageView.superview convertRect:self.imageView.frame toView:self.parentView];
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:kEndFrame];
    tempImageView.image = self.imageView.image;
    [tempImageView xwDrawCornerWithRadiuce:8];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.parentView addSubview:tempImageView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
    
    [self.collectionHelper removeCurrentPlayer];
}

- (void)effectButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.collectionHelper.showTimeEffect = sender.selected;
}

- (void)saveButtonClicked:(UIButton *)sender
{
    
    LCPPlayerDataModel *model = self.dataArray[self.collectionHelper.currentPage];
    NSString *videoStr = model.dynamicVedioStr;
    
    NSString *videoPath =  [[QSPDownloadTool shareInstance]pathWithURL:videoStr];
    NSString *imageURLPath = model.staticImageStr;
    NSString *dynamicVideoPath = model.dynamicVedioStr;
    
    UIImage *image = self.collectionHelper.currentImageView.image; //iCloud存储的图片
    NSString *uploadName = [self nameWithURLStr:model.staticImageStr];  //存储图片的地址
    
    if([dynamicVideoPath containsString:@"Hot"]||[dynamicVideoPath containsString:@"Subject"]){
        //如果没有视频,就存储一张照片
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Fail", nil) block:nil];
                });
            }
        }];
    }else{
        //如果有视频,要先合成,在存储
        NSString *fileName = [[QSPDownloadTool shareInstance]nameWithURLStr:dynamicVideoPath];
        if(![[NSUserDefaults standardUserDefaults]boolForKey:fileName]){
            [self showHint:NSLocalizedString(@"Wait Please", nil)];
            return;
        }
        
        [XWHudView showHUD];
        NSURL * videoUrl=  [NSURL fileURLWithPath:videoPath];
        [LivePhotoMaker makeLivePhotoByLibrary:videoUrl completed:^(NSDictionary * resultDic) {
            if(resultDic) {
                NSURL * videoUrl = resultDic[@"MOVPath"];
                NSURL * imageUrl = resultDic[@"JPGPath"];
                [LivePhotoMaker saveLivePhotoToAlbumWithMovPath:videoUrl ImagePath:imageUrl completed:^(BOOL isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XWHudView hideHUD];
                        if(isSuccess) {
                            [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];
                        } else {
                            [XWMessageAlertView showSuccess:NSLocalizedString(@"Fail", nil) block:nil];
                        }
                    });
                }];
            }
        }];
    }
    
    
//    BZSaveAlertView *alertView = [[BZSaveAlertView alloc]initWithStyle:XWBaseAlertViewStyleBottom];
//    LCPPlayerDataModel *model = self.dataArray[self.collectionHelper.currentPage];
//    NSString *videoStr = model.dynamicVedioStr;
//    NSString *videoPath =  [[QSPDownloadTool shareInstance]pathWithURL:videoStr];
//    alertView.videoPath = videoPath;
//    alertView.imageURLPath = model.staticImageStr;
//    alertView.dynamicVideoPath = model.dynamicVedioStr;
//
//    alertView.image = self.collectionHelper.currentImageView.image; //iCloud存储的图片
//    NSString *name = [self nameWithURLStr:model.staticImageStr];  //存储图片的地址
//    alertView.uploadName = name;
//
//    [self addSubview:alertView];
//    [alertView appearAnimation];
    
}

//文件名称获取
- (NSString *)nameWithURLStr:(NSString *)urlStr
{
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSString *string = [NSString stringWithFormat:@"%@%@%@",array[array.count-3],array[array.count-2],array[array.count-1]];
    return string;
}

- (void)collectButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(!sender.selected){
        LCPPlayerDataModel *model = self.dataArray[self.collectionHelper.currentPage];
        [[XWCollectManager sharedXWCollectManager]cancelCollectWithModel:model];
    }else{
        LCPPlayerDataModel *model = self.dataArray[self.collectionHelper.currentPage];
        [[XWCollectManager sharedXWCollectManager]collectWithModel:model];
    }
}

#pragma mark - private
- (void)configureBrowser
{
    [self baseUIConfig];
    [self baseConstriantsConfig];
    
    self.collectionHelper.dataArray = self.dataArray;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    //判断当前是否收藏
    BOOL select = [[XWCollectManager sharedXWCollectManager]isCollectWithModel:self.dataArray[self.collectionHelper.currentPage]];
    self.collectButton.selected = select;
}

- (void)animateImageViewAtIndex:(NSInteger)index {
    
    self.backgroundColor = [[UIColor xwColorWithHexString:@"#F5F7FB"]colorWithAlphaComponent:0.0];
    self.saveButton.alpha = 0.0;
    self.effectButton.alpha = 0.0;
    self.collectButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.collectionView.hidden = YES;
    
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:self.parentView];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.image = self.imageView.image;
    [tempImageView xwDrawCornerWithRadiuce:10];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;

    UIImageView *framImageView = [[UIImageView alloc]initWithFrame:kStartPhone];
    framImageView.image = XWImageName(@"frame");
    framImageView.alpha = 0.0;
    
    [self.superview addSubview:tempImageView];
    [self.superview addSubview:framImageView];
    
    //Spring Animation
    /*
     0.添加白色底部
     1.移如图片
     2.移入手机框
     3.渐变进入
     */
    
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundColor = [[UIColor xwColorWithHexString:@"#F5F7FB"]colorWithAlphaComponent:1.0];
//                         framImageView.alpha = 1.0;
                         tempImageView.frame = kEndFrame;
                     }
                     completion:^(BOOL finished) {
                         //第二步
                         [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                             framImageView.frame = kEndPhone;
                             framImageView.alpha = 1.0;
                             
                             self.saveButton.alpha = 1.0;
                             self.effectButton.alpha = 1.0;
                             self.collectButton.alpha = 1.0;
                             self.backButton.alpha = 1.0;
                             
                         } completion:^(BOOL finished) {
                             
                             //第三步
                             self.collectionView.hidden = NO;
                             [tempImageView removeFromSuperview];
                             [framImageView removeFromSuperview];
                             
                         }];
                     }];
}

#pragma mark - BZCollectionViewFlowLayoutDelegate
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page
{
//    NSLog(@"%d",page);
}

#pragma mark - setter & getter

- (UICollectionView *)collectionView
{
    if(!_collectionView){
        BZCollectionViewFlowLayout *flowLayout = [[BZCollectionViewFlowLayout alloc] init];
        flowLayout.delegate = self;
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kSCROLLTOP, kSCROLLWIDTH, kSCROLLHEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self.collectionHelper;
        _collectionView.dataSource = self.collectionHelper;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[BZPhoneBrowerCell class] forCellWithReuseIdentifier:kBZPhoneBrowerCell];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (BZCollectionHelper *)collectionHelper
{
    if(!_collectionHelper){
        _collectionHelper = [[BZCollectionHelper alloc]init];
        _collectionHelper.collectionView = self.collectionView;
        kXWWeakSelf(weakSelf);
        _collectionHelper.collectBlock = ^(BOOL isCollect) {
            weakSelf.collectButton.selected = isCollect;
        };
    }
    return _collectionHelper;
}

- (UIButton *)backButton{
    if(!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:XWImageName(@"叉") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)effectButton
{
    if(!_effectButton){
        _effectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_effectButton xwDrawCornerWithRadiuce:29];
        [_effectButton setImage:XWImageName(@"组20") forState:UIControlStateNormal];
        [_effectButton setImage:XWImageName(@"组23ontouch") forState:UIControlStateSelected];
        [_effectButton addTarget:self action:@selector(effectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effectButton;
}
- (UIButton *)saveButton
{
    if(!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton xwDrawCornerWithRadiuce:29];
        [_saveButton setImage:XWImageName(@"组22") forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (UIButton *)collectButton
{
    if(!_collectButton){
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton xwDrawCornerWithRadiuce:29];
        [_collectButton setImage:XWImageName(@"未收藏") forState:UIControlStateNormal];
        [_collectButton setImage:XWImageName(@"已收藏") forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

@end
