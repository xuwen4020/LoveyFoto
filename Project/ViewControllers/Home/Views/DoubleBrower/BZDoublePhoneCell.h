//
//  BZDoublePhoneCell.h
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const kBZDoublePhoneCellIdentifier = @"BZDoublePhoneCell";

@interface BZDoublePhoneCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *leftImageview;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) NSString *leftfileName;
@property (nonatomic,strong) NSString *rightfileName;
@property (nonatomic,assign) BOOL canPlay;
@property (nonatomic,assign) BOOL showTime;

- (void)removePlayer;
- (void)loadVidioWithName:(NSString *)leftVideoName name:(NSString *)rightVidioName;
//前后移除 play;
- (void)stopPlay;


- (void)loadStart;
- (void)loadStop;

@end
