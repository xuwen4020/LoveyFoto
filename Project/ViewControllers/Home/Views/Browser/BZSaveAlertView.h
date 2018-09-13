//
//  BZSaveAlertView.h
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBaseAlertView.h"

@interface BZSaveAlertView : XWBaseAlertView
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *uploadName;
@property (nonatomic,strong) NSString *dynamicVideoPath;

@property (nonatomic,strong) NSString *imageURLPath; //图片路径
@property (nonatomic,strong) NSString *videoPath; //视频路径


@end
