//
//  XWChooseImageButton.h
//  Project
//
//  Created by xuwen on 2018/7/31.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseImageBlock)(UIImage *image);
@interface XWChooseImageButton : UIButton
//是否选择了图片
@property (nonatomic,assign,readonly) BOOL isChooseImage;
//ViewController
@property (nonatomic,strong) UIViewController *eventVC;

@property (nonatomic,copy) ChooseImageBlock chooseImageBlock;

//init
- (instancetype)initWithFrame:(CGRect)frame eventViewController:(UIViewController *)eventVC;
@end
