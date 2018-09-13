//
//  BZSaveAlertView.m
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSaveAlertView.h"
#import <Photos/Photos.h>
#import <CloudKit/CloudKit.h>
#import "LivePhotoMaker.h"
#import "XWMessageAlertView.h"
#import "QSPDownloadTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LivePhotoMaker.h"

#import "LZiCloud.h"
#import "LZDocument.h"
#import "LZiCloudDocument.h"

@interface BZSaveAlertView()
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIView *saveView;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *saveiCloudButton;
@property (nonatomic,strong) NSURL *iCloudURL;
@property (nonatomic,strong) NSString *localFileStr;
@end

@implementation BZSaveAlertView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

#pragma mark - public

#pragma mark - private

#pragma mark - event
- (void)cancelButtonClicked:(UIButton *)sender
{
    [self disappearAnimation];
}

- (void)saveToLocalButtonClicked:(UIButton *)sender
{
    if([self.dynamicVideoPath containsString:@"(null)"]){
        kXWWeakSelf(weakSelf);
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];
                    [weakSelf disappearAnimation];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf disappearAnimation];
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Fail", nil) block:nil];
                });
            }
        }];
    }else{
        
        NSString *fileName = [[QSPDownloadTool shareInstance]nameWithURLStr:self.dynamicVideoPath];
        if(![[NSUserDefaults standardUserDefaults]boolForKey:fileName]){
            [self showHint:NSLocalizedString(@"Wait Please", nil)];
            return;
        }
        
        [XWHudView showHUD];
        NSURL * videoUrl=  [NSURL fileURLWithPath:self.videoPath];
        [LivePhotoMaker makeLivePhotoByLibrary:videoUrl completed:^(NSDictionary * resultDic) {
            if(resultDic) {
                NSURL * videoUrl = resultDic[@"MOVPath"];
                NSURL * imageUrl = resultDic[@"JPGPath"];
                [LivePhotoMaker saveLivePhotoToAlbumWithMovPath:videoUrl ImagePath:imageUrl completed:^(BOOL isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XWHudView hideHUD];
                        [self disappearAnimation];
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

- (void)saveiCloudButtonClickde:(UIButton *)sender
{
    NSLog(@"保存图片到 iCloud云盘");
    self.iCloudURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (self.iCloudURL == nil) {
        [self showHint:NSLocalizedString(@"Please turn on iCloud First", nil)];
    } else {
        NSLog(@"iCloud开启");
        //存储照片到本地,获取到本地地址
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"path = %@",path);
        NSString *filename=[path stringByAppendingPathComponent:self.uploadName];
        NSData *data= UIImagePNGRepresentation(self.image);

        if([data writeToFile:filename atomically:YES]){
            NSLog(@"写入成功");
            self.localFileStr = [NSString stringWithString:filename];
            [NSThread detachNewThreadSelector:@selector(uploadICloud) toTarget:self withObject:nil];
        }else{
            [XWMessageAlertView showSuccess:NSLocalizedString(@"Fail", nil) block:nil];
        }
    }
//    [self iCloudDocumentTest];
}


- (void)iCloudDocumentTest {
    UIImage *img = self.image;
    NSData *da = UIImageJPEGRepresentation(img, 1.0);
    LZDocument *doc = [[LZDocument alloc]initWithFileURL:[LZiCloudDocument localFileUrl:@"userData"]];
    doc.data =da;
    [doc saveToURL:[LZiCloudDocument localFileUrl:@"userData"] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            [LZiCloudDocument uploadToiCloud:@"userData" localFile:@"userData" callBack:^(BOOL success) {
                if (success) {
                    NSLog(@"success upload to iCloud");
                }
            }];
        }
    }];
}


- (void)uploadICloud
{
    self.iCloudURL = [NSURL URLWithString:self.uploadName relativeToURL:self.iCloudURL];
    NSString *localFilePath = self.localFileStr;
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断本地文件是否存在
    if ([manager fileExistsAtPath:localFilePath]){
        NSData *data = [NSData dataWithContentsOfFile:localFilePath];
        // 判断iCloud里该文件是否存在
        if ([manager isUbiquitousItemAtURL:self.iCloudURL]) {
            NSError *error = nil;
            [data writeToURL:self.iCloudURL options:NSDataWritingAtomic error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];
                [self disappearAnimation];
            });
        }else{
            NSURL *fileUrl = [NSURL fileURLWithPath:localFilePath];
            NSError *error = nil;
            if([manager setUbiquitous:YES itemAtURL:fileUrl destinationURL:self.iCloudURL error:&error]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Save successfully", nil) block:nil];;
                    [self disappearAnimation];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWMessageAlertView showSuccess:NSLocalizedString(@"Fail", nil) block:nil];
                    [self disappearAnimation];
                });
            }
        }
    }
}


#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.placeView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3];;
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.cancelButton];
    [self.placeView addSubview:self.saveView];
    [self.saveView addSubview:self.saveButton];
    [self.saveView addSubview:self.saveiCloudButton];
}

- (void)baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-kSafeAreaBottomHeight-15);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@57);
    }];
    [self.saveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-10);
        make.height.equalTo(@117);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saveView);
        make.right.equalTo(self.saveView);
        make.top.equalTo(self.saveView);
        make.height.equalTo(@57);
    }];
    [self.saveiCloudButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saveView);
        make.right.equalTo(self.saveView);
        make.bottom.equalTo(self.saveView);
        make.height.equalTo(@57);
    }];
}

#pragma mark - setter & getter
- (UIButton *)cancelButton
{
    if(!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton commonButtonConfigWithTitle:NSLocalizedString(@"Cancel", nil) font:Font(24) titleColor:[UIColor xwColorWithHexString:@"#007AFF"] aliment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton xwDrawCornerWithRadiuce:14];
    }
    return _cancelButton;
}

- (UIView *)saveView
{
    if(!_saveView){
        _saveView = [[UIView alloc]init];
        _saveView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
        [_saveView xwDrawCornerWithRadiuce:14];
    }
    return _saveView;
}
- (UIButton *)saveButton
{
    if(!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton commonButtonConfigWithTitle:NSLocalizedString(@"Save pictures", nil) font:Font(24) titleColor:[UIColor xwColorWithHexString:@"#007AFF"] aliment:UIControlContentHorizontalAlignmentCenter];
        [_saveButton addTarget:self action:@selector(saveToLocalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)saveiCloudButton
{
    if(!_saveiCloudButton){
        _saveiCloudButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveiCloudButton commonButtonConfigWithTitle:NSLocalizedString(@"Save to iCloud", nil) font:Font(24) titleColor:[UIColor xwColorWithHexString:@"#007AFF"] aliment:UIControlContentHorizontalAlignmentCenter];
        [_saveiCloudButton addTarget:self action:@selector(saveiCloudButtonClickde:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveiCloudButton;
}

@end
