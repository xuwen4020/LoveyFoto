//
//  LCPHTTPRequestManager.h
//  LycamPlusMediumLiveDemo
//
//  Created by fengshicao on 16/4/21.
//  Copyright © 2016年 fengshicao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HttpRequestType) {
    kHttpRequestTypePost = 1,
    kHttpRequestTypeGet = 2,
    kHttpRequestTypeDelete = 3,
    kHttpRequestTypePut = 4
};

typedef void(^SuccessBlock)(BOOL success,id JSON);
typedef void(^FailureBlock)(BOOL failuer, NSError *error);
typedef void(^ExistBlock)(BOOL exist, id JSON);


@interface LCPHTTPRequestManager : NSObject


@property (nonatomic, assign) HttpRequestType httpRequestType;

+ (NSURLSessionTask *)downLoadVedioWithFullPath:(NSString *)fullPath url:(NSString *)urlStr
                         progress:(void (^)(NSProgress *downloadProgress,NSString *url)) downloadProgressBlock
                          success:(void(^)(BOOL success,id JSON,NSString *url))successBlock
                          failure:(void(^)(BOOL failuer, NSError *error,NSString *url))failureBlock
                            exist:(ExistBlock)existBlock;

/**
 *  POST网络请求
 *
 *  @param pathUrl    URL地址
 *  @param parameters 参数
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+ (void)postWithPathUrl:(NSString *)pathUrl
             parameters:(NSDictionary *)parameters
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

/**
 *  GET网络请求
 *
 *  @param pathUrl    URL地址
 *  @param parameters 参数
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+ (void)getWithPathUrl:(NSString *)pathUrl
            parameters:(NSDictionary *)parameters
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;

/**
 *  DELETE网络请求
 *
 *  @param pathUrl    URL地址
 *  @param parameters 参数
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

+ (void)deleteWithPathUrl:(NSString *)pathUrl
               parameters:(NSDictionary *)parameters
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

/**
 *  PUT网络请求
 *
 *  @param pathUrl    URL地址
 *  @param parameters 参数
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

+ (void)putWithPathUrl:(NSString *)pathUrl
            parameters:(NSDictionary *)parameters
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;

+ (void)getQQWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  下载网络图片
 *
 *  @param urlPath         图片路径
 *  @param placehoderImage 图片初始图片（传一个图片，不选择字符串是因为这个图片可能外部需要拉伸）
 *  @param imageView       添加目的地址
 */
+ (void)downloadImageWithURL:(NSString *)urlPath
             placehoderImage:(UIImage *)placehoderImage
                   imageView:(UIImageView *)imageView;


+ (void)uploadImageWithURL:(NSString *)urlPath
                parameters:(NSMutableDictionary *)parameters
               uploadImage:(UIImage *)uploadImage
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;

/**上传用户photos*/
+ (void)uploadUserPhotosImageWithURL:(NSString *)urlPath parameters:(NSMutableDictionary *)parameters uploadImage:(UIImage *)uploadImage success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)uploadReportImageWithURL:(NSString *)urlPath
                parameters:(NSMutableDictionary *)parameters
               uploadImage:(UIImage *)uploadImage
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;

+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;

@end
