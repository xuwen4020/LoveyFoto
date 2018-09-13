//
//  XWBrowserView.h
//  Project
//
//  Created by xuwen on 2018/8/16.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ __nullable DismissBlock)(UIImage * __nullable image, NSInteger index);

#define kEDGE 15   //框框与屏幕的边距
#define kWidthRatHeight 232/493  //长宽比例

#define kFRAME_TOP (kStatusBarHeight+30)   //上边距
#define kFRAME_BOTTOM (kSafeAreaBottomHeight+120)  //下边距
#define kFRAME_HEIGHT (kSCREEN_HEIGHT - (kFRAME_TOP +kFRAME_BOTTOM))

#define kSCROLLTOP     (kFRAME_TOP-kEDGE)
#define kSCROLLWIDTH   kSCREEN_WIDTH
#define kSCROLLHEIGHT  (kFRAME_HEIGHT+kEDGE*2)

#define kShowWidth (kFRAME_HEIGHT)*kWidthRatHeight
#define kShowFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0, kEDGE, kShowWidth, kFRAME_HEIGHT)
#define kPhoneFrame CGRectMake((kSCREEN_WIDTH-kShowWidth)/2.0-kEDGE, 0, kShowWidth+kEDGE*2, kFRAME_HEIGHT+kEDGE*2)

@interface XWBrowserView : UIView
/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)URLStrings placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index parentView:(nullable UIView *)parentView category:(nullable NSString *)category dismiss:(DismissBlock)block;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;
@end
