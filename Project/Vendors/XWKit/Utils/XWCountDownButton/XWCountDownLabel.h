//
//  XWCountDownLabel.h
//  Project
//
//  Created by XuWen on 2018/5/1.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWCountDownLabel : UILabel
+ (instancetype)sharedInstance;
- (void)show;
- (void)hiden;

@end
