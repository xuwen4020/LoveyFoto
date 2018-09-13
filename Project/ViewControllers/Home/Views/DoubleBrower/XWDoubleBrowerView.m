//
//  XWDoubleBrowerView.m
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWDoubleBrowerView.h"
#import "BZCashTool.h"
#import "BZDoublePhoneHelper.h"
#import "BZDoublePhoneCell.h"
#import "BZCollectionViewFlowLayout.h"
#import "QSPDownloadTool.h"
#import "XWCollectManager.h"
#import "LivePhotoMaker.h"
#import "XWMessageAlertView.h"

//#define kEndLeftImageFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0, kSCROLLTOP+kEDGE, kShowWidth, kFRAME_HEIGHT)
//#define kEndRightImageFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0, kSCROLLTOP+kEDGE, kShowWidth, kFRAME_HEIGHT)

@interface XWDoubleBrowerView()<BZCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic, copy) DismissBlock dismissDlock;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BZDoublePhoneHelper *collectionHelper;

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *effectButton;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *collectButton;

//数据
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic) NSInteger index;

@property (nonatomic,assign) BOOL leftSave;
@property (nonatomic,assign) BOOL righSave;

@end

@implementation XWDoubleBrowerView

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)leftImageView andImageView:(nullable UIImageView *)rightImageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index parentView:(nullable UIView *)parentView category:(nullable NSString *)category dismiss:(DismissBlock)block
{
    XWDoubleBrowerView *browser = [[XWDoubleBrowerView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    browser.backgroundColor = [UIColor xwColorWithHexString:@"#F5F7FB"];
    browser.index = index;
    browser.collectionHelper.currentPage = index;
    browser.leftImageView = leftImageView;
    browser.rightImageView = rightImageView;
    browser.parentView = parentView;
    browser.dataArray = URLStrings;
    //    browser.URLStrings = URLStrings;
    browser.dismissDlock = block;
    [browser configureBrowser];
    [browser animateImageViewAtIndex:index];
    
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

#pragma mark - baseUIConfig
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

#pragma mark - private
- (void)configureBrowser
{
    [self baseUIConfig];
    [self baseConstriantsConfig];
    
    self.collectionHelper.dataArray = self.dataArray;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//
//    //判断当前是否收藏
//    BOOL select = [[XWCollectManager sharedXWCollectManager]isCollectWithModel:self.dataArray[self.collectionHelper.currentPage]];
//    self.collectButton.selected = select;
}

- (void)animateImageViewAtIndex:(NSInteger)index
{
    self.backgroundColor = [[UIColor xwColorWithHexString:@"#F5F7FB"]colorWithAlphaComponent:0.0];
    self.saveButton.alpha = 0.0;
    self.effectButton.alpha = 0.0;
    self.collectButton.alpha = 0.0;
    self.backButton.alpha = 0.0;
    self.collectionView.hidden = YES;
    
    CGRect leftStartFrame = [self.leftImageView.superview convertRect:self.leftImageView.frame toView:self.parentView];
    CGRect rightStartFrame = [self.rightImageView.superview convertRect:self.rightImageView.frame toView:self.parentView];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:leftStartFrame];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightStartFrame];
    leftImageView.image = self.leftImageView.image;
    rightImageView.image = self.rightImageView.image;
    [leftImageView xwDrawCornerWithRadiuce:8];
    [rightImageView xwDrawCornerWithRadiuce:8];
//    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
//    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *phoneLeftImageView = [[UIImageView alloc]initWithFrame:kDOUBLE_LEFT_TempPhoneFrame];
    UIImageView *phoneRightImageView = [[UIImageView alloc]initWithFrame:kDOUBLE_RIGHT_TempPhoneFrame];
    phoneLeftImageView.image = XWImageName(@"frame");
    phoneRightImageView.image = XWImageName(@"frame");
    phoneLeftImageView.alpha = 0.0;
    phoneRightImageView.alpha = 0.0;
    
    [self.superview addSubview:leftImageView];
    [self.superview addSubview:rightImageView];
    [self.superview addSubview:phoneLeftImageView];
    [self.superview addSubview:phoneRightImageView];
    
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.backgroundColor = [[UIColor xwColorWithHexString:@"#F5F7FB"]colorWithAlphaComponent:1.0];
                         leftImageView.frame = kDOUBLE_LEFT_TempFrame;
                         rightImageView.frame = kDOUBLE_RIGHT_TempFrame;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            phoneLeftImageView.frame = kDOUBLE_LEFT_TempPhoneFrame;
            phoneRightImageView.frame = kDOUBLE_RIGHT_TempPhoneFrame;
            phoneLeftImageView.alpha = 1.0;
            phoneRightImageView.alpha = 1.0;
            self.saveButton.alpha = 1.0;
            self.effectButton.alpha = 1.0;
            self.collectButton.alpha = 1.0;
            self.backButton.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.collectionView.hidden = NO;
            [leftImageView removeFromSuperview];
            [rightImageView removeFromSuperview];
            [phoneLeftImageView removeFromSuperview];
            [phoneRightImageView removeFromSuperview];
        }];

    }];
    
}

#pragma mark - event

- (void)backButtonClicked:(UIButton *)sender
{
    self.dismissDlock(nil, 1);
    CGRect leftEndFrame = [self.leftImageView.superview convertRect:self.leftImageView.frame toView:self.parentView];
    CGRect rightEndFrame = [self.rightImageView.superview convertRect:self.rightImageView.frame toView:self.parentView];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:kDOUBLE_LEFT_TempFrame];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:kDOUBLE_RIGHT_TempFrame];
    leftImageView.image = self.leftImageView.image;
    rightImageView.image = self.rightImageView.image;
    [leftImageView xwDrawCornerWithRadiuce:8];
    [rightImageView xwDrawCornerWithRadiuce:8];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.parentView addSubview:leftImageView];
    [self.parentView addSubview:rightImageView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        leftImageView.frame = leftEndFrame;
        rightImageView.frame = rightEndFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [leftImageView removeFromSuperview];
        [rightImageView removeFromSuperview];
    }];
    
    [self.collectionHelper.currentDoubleCell removePlayer];
}

- (void)effectButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.collectionHelper.showTimeEffect = sender.selected;
}

- (void)saveButtonClicked:(UIButton *)sender
{
    self.leftSave = NO;
    self.righSave = NO;
    
    LCPPlayerDataModel *leftModel = self.dataArray[self.collectionHelper.currentPage*2];
    [self saveWithModel:leftModel isLeft:YES];
}

- (void)saveWithModel:(LCPPlayerDataModel *)model  isLeft:(BOOL)isLeft
{
    NSString *videoStr = model.dynamicVedioStr;
    NSString *videoPath =  [[QSPDownloadTool shareInstance]pathWithURL:videoStr];
    NSString *dynamicVideoPath = model.dynamicVedioStr;
    UIImage *image = self.collectionHelper.currentImageView.image; //iCloud存储的图片
    kXWWeakSelf(weakSelf);
    if([dynamicVideoPath containsString:@"Hot"]||[dynamicVideoPath containsString:@"Subject"]){
        //如果没有视频,就存储一张照片
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isLeft){
                        LCPPlayerDataModel *rightModel = self.dataArray[self.collectionHelper.currentPage*2+1];
                        [weakSelf saveWithModel:rightModel isLeft:NO];
                    }else{
                        [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];
                    }
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
}


- (void)collectButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(!sender.selected){
        LCPPlayerDataModel *modelleft = self.dataArray[self.collectionHelper.currentPage*2];
        [[XWCollectManager sharedXWCollectManager]cancelCollectWithModel:modelleft];
        LCPPlayerDataModel *modelright = self.dataArray[self.collectionHelper.currentPage*2+1];
        [[XWCollectManager sharedXWCollectManager]cancelCollectWithModel:modelright];
    }else{
        LCPPlayerDataModel *modelleft = self.dataArray[self.collectionHelper.currentPage*2];
        [[XWCollectManager sharedXWCollectManager]collectWithModel:modelleft];
        LCPPlayerDataModel *modelright = self.dataArray[self.collectionHelper.currentPage*2+1];
        [[XWCollectManager sharedXWCollectManager]collectWithModel:modelright];
    }
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
        [_collectionView registerClass:[BZDoublePhoneCell class] forCellWithReuseIdentifier:kBZDoublePhoneCellIdentifier];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (BZDoublePhoneHelper *)collectionHelper
{
    if(!_collectionHelper){
        _collectionHelper = [[BZDoublePhoneHelper alloc]init];
        _collectionHelper.collectionView = self.collectionView;
//        kXWWeakSelf(weakSelf);
//        _collectionHelper.collectBlock = ^(BOOL isCollect) {
//            weakSelf.collectButton.selected = isCollect;
//        };
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
