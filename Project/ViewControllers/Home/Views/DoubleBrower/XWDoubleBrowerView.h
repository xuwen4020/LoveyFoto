//
//  XWDoubleBrowerView.h
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWBrowserView.h"

#define kDOUBLE_EMPTY 14
#define kDOUBLE_EDEG  8
#define kCenter_EMPTY 4
#define kDOUBLE_FRAME_WIDTH ((kSCREEN_WIDTH-(kDOUBLE_EMPTY*2+kDOUBLE_EDEG+kDOUBLE_EDEG*4+kCenter_EMPTY))/2.0)
#define kDOUBLE_FRAME_HEIGHT (kDOUBLE_FRAME_WIDTH/232*493)
#define kDOUBLE_FRAME_Y ((kSCROLLHEIGHT-kDOUBLE_FRAME_HEIGHT)/2.0)

//手机内容 frame
#define kDOUBLE_LEFT_Frame CGRectMake((kDOUBLE_EMPTY+kDOUBLE_EDEG), kDOUBLE_FRAME_Y, kDOUBLE_FRAME_WIDTH, kDOUBLE_FRAME_HEIGHT)
#define kDOUBLE_RIGHT_Frame CGRectMake(kSCREEN_WIDTH-kDOUBLE_FRAME_WIDTH-kDOUBLE_EDEG-kDOUBLE_EMPTY, kDOUBLE_FRAME_Y, kDOUBLE_FRAME_WIDTH, kDOUBLE_FRAME_HEIGHT)
//手机壳 frame
#define kDOUBLE_LEFT_PhoneFrame CGRectMake((kDOUBLE_EMPTY+kDOUBLE_EDEG-kDOUBLE_EDEG), kDOUBLE_FRAME_Y-kDOUBLE_EDEG, kDOUBLE_FRAME_WIDTH+(kDOUBLE_EDEG*2), kDOUBLE_FRAME_HEIGHT+(kDOUBLE_EDEG*2))
#define kDOUBLE_RIGHT_PhoneFrame CGRectMake(kSCREEN_WIDTH-kDOUBLE_FRAME_WIDTH-kDOUBLE_EDEG-kDOUBLE_EMPTY-kDOUBLE_EDEG, kDOUBLE_FRAME_Y-kDOUBLE_EDEG, kDOUBLE_FRAME_WIDTH+(kDOUBLE_EDEG*2), kDOUBLE_FRAME_HEIGHT+(kDOUBLE_EDEG*2))

//闪现 内容frame
#define kDOUBLE_LEFT_TempFrame CGRectMake((kDOUBLE_EMPTY+kDOUBLE_EDEG), kDOUBLE_FRAME_Y+kSCROLLTOP, kDOUBLE_FRAME_WIDTH, kDOUBLE_FRAME_HEIGHT)
#define kDOUBLE_RIGHT_TempFrame CGRectMake(kSCREEN_WIDTH-kDOUBLE_FRAME_WIDTH-kDOUBLE_EDEG-kDOUBLE_EMPTY, kDOUBLE_FRAME_Y+kSCROLLTOP, kDOUBLE_FRAME_WIDTH, kDOUBLE_FRAME_HEIGHT)

//闪现 手机frame
#define kDOUBLE_LEFT_TempPhoneFrame CGRectMake((kDOUBLE_EMPTY+kDOUBLE_EDEG-kDOUBLE_EDEG), kDOUBLE_FRAME_Y+kSCROLLTOP-kDOUBLE_EDEG, kDOUBLE_FRAME_WIDTH+(kDOUBLE_EDEG*2), kDOUBLE_FRAME_HEIGHT+(kDOUBLE_EDEG*2))

#define kDOUBLE_RIGHT_TempPhoneFrame CGRectMake(kSCREEN_WIDTH-kDOUBLE_FRAME_WIDTH-kDOUBLE_EDEG-kDOUBLE_EMPTY-kDOUBLE_EDEG, kDOUBLE_FRAME_Y+kSCROLLTOP-kDOUBLE_EDEG, kDOUBLE_FRAME_WIDTH+(kDOUBLE_EDEG*2), kDOUBLE_FRAME_HEIGHT+(kDOUBLE_EDEG*2))

typedef void(^ __nullable DismissBlock)(UIImage * __nullable image, NSInteger index);

@interface XWDoubleBrowerView : UIView
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)leftImageView andImageView:(nullable UIImageView *)rightImageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index parentView:(nullable UIView *)parentView category:(nullable NSString *)category dismiss:(DismissBlock)block;

@end
