//
//  UIImage+XWUtils.h
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XWUtils)
/** 压缩图片*/
- (UIImage *)xwZipImage;
/** 缩放图片*/
- (UIImage *)xwImagescaledToSize:(CGSize)newSize;

/** 将图片保存到本地 */
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key;
/** 获取本地图片 */
+ (UIImage*)GetImageFromLocal:(NSString*)key;

+ (NSString *)GetPathWithKey:(NSString*)key;

@end
