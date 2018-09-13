//
//  XWMessageAlertView.h
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XWMessageAlertViewDismissBlock)(void);
@interface XWMessageAlertView : UIView
+ (void)showSuccess:(NSString *)message block:(XWMessageAlertViewDismissBlock)block;
@end
