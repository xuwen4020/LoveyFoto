//
//  BZPhoneBrowerCell.h
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSPDownloadTool.h"
#import "XWBrowserView.h"




static NSString *const kBZPhoneBrowerCell = @"BZPhoneBrowerCell";
@interface BZPhoneBrowerCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,assign) BOOL canPlay;
@property (nonatomic,assign) BOOL showTime;

- (void)removePlayer;
- (void)loadVidioWithName:(NSString *)videoName;
- (void)downLoadVideoWithName:(NSString *)videoName;
- (void)prepareVideoWithName:(NSString *)videoName;

- (void)loadStart;
- (void)loadStop;

@end
