//
//  UIImage+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIImage+XWUtils.h"

#define kImageMaxWidth 375
#define kImageMaxHeight 200
#define kImageMaxMemory 100 * kOSXHex
#define kOSXHex 1000

@implementation UIImage (XWUtils)
/** 压缩图片*/
- (UIImage *)xwZipImage
{
    CGSize imageSize = self.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat currentResolution = imageWidth * imageHeight;
    CGFloat maxResolution = kImageMaxWidth * kImageMaxHeight;
    UIImage *newImage = self;
    
    if (currentResolution > maxResolution) {
        NSLog(@"比例过大，缩放....");
        newImage = [self xwImagescaledToSize:CGSizeMake(kImageMaxWidth, kImageMaxHeight)];
        NSLog(@"新的比例为: %.2f %.2f", newImage.size.width, newImage.size.height);
    }
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    NSLog(@"内部data原始大小 : %lu", data.length);
    if (data.length>100 * kOSXHex) {
        newImage = [newImage zipImageContinually];
    }
    
    return newImage;
}

/** 缩放图片*/
- (UIImage *)xwImagescaledToSize:(CGSize)newSize
{
    UIImage *newImage = self;
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length <= 100 * kOSXHex) {
        return newImage;
    }
    
    CGFloat compression = 1.0f;
    while ([data length] > 100 * kOSXHex && compression >= 0.01) {
        compression -= 0.01;
        data = UIImageJPEGRepresentation(newImage, compression);
    }
    
    return [UIImage imageWithData:data];
}

#pragma mark - private

- (UIImage *)zipImageContinually {
    
    UIImage *newImage = self;
    
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length <= 100 * kOSXHex) {
        return newImage;
    }
    
    CGFloat compression = 1.0f;
    while ([data length] > 100 * kOSXHex && compression >= 0.01) {
        compression -= 0.01;
        data = UIImageJPEGRepresentation(newImage, compression);
    }
    
    return [UIImage imageWithData:data];
}

/** 将图片保存到本地 */
+ (void)SaveImageToLocal:(UIImage*)image Keys:(NSString*)key
{
    //首先,需要获取沙盒路径
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *picPath = [dirArray firstObject];
    picPath = [picPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@",key]];
    
    NSData *imgData = UIImageJPEGRepresentation(image,0.8);
    if([imgData writeToFile:picPath atomically:YES]){
        NSLog(@"存储成功");
    }else{
        NSLog(@"存储失败");
    }
}

/** 获取本地图片 */
+ (UIImage*)GetImageFromLocal:(NSString*)key
{
    //读取本地图片非resource
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *picPath = [dirArray firstObject];
    picPath = [picPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@",key]];

    NSLog(@"获取图片   %@",picPath);
    UIImage *img=[[UIImage alloc]initWithContentsOfFile:picPath];
    return img;
}
/** 获取本地图片地址 */
+ (NSString *)GetPathWithKey:(NSString*)key
{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *picPath = [dirArray firstObject];
    picPath = [picPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@",key]];

    return picPath;
}

@end
