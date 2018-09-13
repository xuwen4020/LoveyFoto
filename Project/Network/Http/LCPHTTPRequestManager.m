//
//  LCPHTTPRequestManager.m
//  LycamPlusMediumLiveDemo
//
//  Created by fengshicao on 16/4/21.
//  Copyright © 2016年 fengshicao. All rights reserved.
//

#import "LCPHTTPRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>
#import <UIImageView+WebCache.h>

#define kLCPResponseInvalidCredentials @"Invalid credentials"
#define kLCPRequestSuccessWithCode  @"code"

#define LCP_BASE_URL @""

@implementation LCPHTTPRequestManager

+ (void)requestWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock requestMethod:(HttpRequestType)requestMethod{
    NSURL *baseUrl = [NSURL URLWithString:LCP_BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.f;
    //服务器返回的ContentTypes类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",@"text/css", nil];

    switch (requestMethod) {
        case kHttpRequestTypePost:{
            [manager POST:pathUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if (![[responseObject objectForKey:@"code"] boolValue]) {
                    NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                    failureBlock(NO,error);
                    return ;
                }
                successBlock(YES,responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"--%@",[error localizedDescription]);
                
                NSLog(@"---%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
                NSError * newError = [self httpError:error withUserinfo:nil];
                if(newError.code == 401 && [newError.description rangeOfString:kLCPResponseInvalidCredentials].location != NSNotFound){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLCPResponseInvalidCredentials object:nil];
                }else if (newError.code == -1009 && [newError.description rangeOfString:@"似乎已断开与互联网的连接"].location != NSNotFound) {
                    newError = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:@{NSLocalizedDescriptionKey:@"Network error!"}];
                }
                failureBlock(YES,newError);
            }];
        }break;
        case kHttpRequestTypeGet:{
            [manager GET:pathUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//                if (![[responseObject objectForKey:@"code"] boolValue]) {
//                    NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
//                    failureBlock(NO,error);
//                    return ;
//                }
                successBlock(YES,responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"--%@",[error localizedDescription]);
                
                NSLog(@"---%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
                
                NSError * newError = [self httpError:error withUserinfo:nil];
                if(newError.code == 401 && [newError.description rangeOfString:kLCPResponseInvalidCredentials].location != NSNotFound){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLCPResponseInvalidCredentials object:nil];
                }else if (newError.code == -1009 && [newError.description rangeOfString:@"似乎已断开与互联网的连接"].location != NSNotFound) {
                    newError = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:@{NSLocalizedDescriptionKey:@"Network error!!"}];
                }
                failureBlock(YES,newError);
            }];
        }break;
        case kHttpRequestTypeDelete: {
            [manager DELETE:pathUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (![[responseObject objectForKey:@"code"] boolValue]) {
                    NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                    failureBlock(NO,error);
                    return ;
                }
                successBlock(YES,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"--%@",[error localizedDescription]);
                NSError * newError = [self httpError:error withUserinfo:nil];
                if(newError.code == 401 && [newError.description rangeOfString:kLCPResponseInvalidCredentials].location != NSNotFound){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLCPResponseInvalidCredentials object:nil];
                }else if (newError.code == -1009 && [newError.description rangeOfString:@"似乎已断开与互联网的连接"].location != NSNotFound) {
                    newError = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:@{NSLocalizedDescriptionKey:@"Network error!"}];
                }
                failureBlock(YES,newError);
            }];
        }break;
        case kHttpRequestTypePut: {
            [manager PUT:pathUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (![[responseObject objectForKey:@"code"] boolValue]) {
                    NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                    failureBlock(NO,error);
                    return ;
                }
                successBlock(YES,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"--%@",[error localizedDescription]);
                NSError * newError = [self httpError:error withUserinfo:nil];
                if(newError.code == 401 && [newError.description rangeOfString:kLCPResponseInvalidCredentials].location != NSNotFound){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLCPResponseInvalidCredentials object:nil];
                }else if (newError.code == -1009 && [newError.description rangeOfString:@"似乎已断开与互联网的连接"].location != NSNotFound) {
                    newError = [NSError errorWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:@{NSLocalizedDescriptionKey:@"Network error!"}];
                }
                failureBlock(YES,newError);
            }];
        }
            break;
        default:break;
    }
    
}

- (void)gettime {
    
}

+ (void)postWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithPathUrl:pathUrl parameters:parameters success:successBlock failure:failureBlock requestMethod:kHttpRequestTypePost];
}

+ (void)getWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithPathUrl:pathUrl parameters:parameters success:successBlock failure:failureBlock requestMethod:kHttpRequestTypeGet];
}


+ (void)deleteWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithPathUrl:pathUrl parameters:parameters success:successBlock failure:failureBlock requestMethod:kHttpRequestTypeDelete];
}

+ (void)putWithPathUrl:(NSString *)pathUrl parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithPathUrl:pathUrl parameters:parameters success:successBlock failure:failureBlock requestMethod:kHttpRequestTypePut];
}


+ (void)downloadImageWithURL:(NSString *)urlPath
             placehoderImage:(UIImage *)placehoderImage
                   imageView:(UIImageView *)imageView{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlPath]
                 placeholderImage:placehoderImage
                          options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

+ (void)uploadImageWithURL:(NSString *)urlPath parameters:(NSMutableDictionary *)parameters uploadImage:(UIImage *)uploadImage success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:LCP_BASE_URL]];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"image/jpeg",@"text/html",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:urlPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(uploadImage,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"faceImg"
                                fileName:fileName
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        NSLog(@"上传成功");
        if ([[responseObject objectForKey:kLCPRequestSuccessWithCode] boolValue]) {
            successBlock(YES,responseObject);
        }else {
            NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
            failureBlock(NO,error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"上传失败 is %@",error.localizedDescription);
        failureBlock(NO,error);
    }];
}

+ (NSURLSessionTask *)downLoadVedioWithFullPath:(NSString *)fullPath url:(NSString *)urlStr
                         progress:(void (^)(NSProgress *downloadProgress,NSString *url)) downloadProgressBlock
                          success:(void(^)(BOOL success,id JSON,NSString *url))successBlock
                          failure:(void(^)(BOOL failuer, NSError *error,NSString *url))failureBlock
                            exist:(ExistBlock)existBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//
//
//    NSString *fullPath1 = [[paths objectAtIndex:0]stringByAppendingPathComponent:
//                          [NSString stringWithFormat:@"test.mov"]];  // 保存文件的名称
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@", fullPath];
    if ([fileManager fileExistsAtPath:fileName]) {
        existBlock(YES, nil);
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"downLoadProgress===%f", downloadProgress.fractionCompleted);
        downloadProgressBlock(downloadProgress,urlStr);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"downLoadProgress");
        successBlock(YES,response,urlStr);
    }];
//    [manager downloadTaskWithRequest:request
//                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                                return [NSURL fileURLWithPath:fullPath];
//                            }
//                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//
//                   }];
    [task resume];
    return task;
}


+ (void)uploadUserPhotosImageWithURL:(NSString *)urlPath parameters:(NSMutableDictionary *)parameters uploadImage:(UIImage *)uploadImage success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:LCP_BASE_URL]];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"image/jpeg",@"text/html",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    [manager POST:urlPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(uploadImage,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"photo"
                                fileName:fileName
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        NSLog(@"上传成功");
        if ([[responseObject objectForKey:kLCPRequestSuccessWithCode] boolValue]) {
            successBlock(YES,responseObject);
        }else {
            NSError *error = [NSError errorWithDomain:@"message error" code:-1010 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
            failureBlock(NO,error);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"上传失败 is %@",error.localizedDescription);
        failureBlock(NO,error);
    }];
}



+(NSError *) httpError:(NSError*) error withUserinfo:(NSDictionary*) _userinfo{
    NSError * newError = error;
    if(error){
        NSHTTPURLResponse * responseError=[error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
        
        NSData *data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        
        NSError *errorerror = nil;
        
        id jsonObject = nil;
        if (data) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&errorerror];
        }
        
        if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
            jsonObject = (NSDictionary *)jsonObject;
            NSLog(@"error jsonObject == %@",jsonObject);
        }
        
        if(responseError){
            NSInteger code = responseError.statusCode;
            NSDictionary * userinfo ;
            if(_userinfo)
                userinfo = _userinfo;
            else{
                if ([[jsonObject allKeys] containsObject:@"error_output"]) {
                    userinfo = @{NSLocalizedDescriptionKey:[jsonObject objectForKey:@"error_output"]?:@"请求失败，请稍后再试!",NSLocalizedFailureReasonErrorKey:[jsonObject objectForKey:@"error"]};
                }else {
                    userinfo = @{NSLocalizedDescriptionKey:@"请求失败，请稍后再试!",NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"%ld",code]};
                }
            }
            newError = [NSError errorWithDomain:@"error" code:code userInfo:userinfo];
        }
    }
    return newError;
}

+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

@end
