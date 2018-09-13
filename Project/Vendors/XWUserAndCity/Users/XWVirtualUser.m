//
//  XWVirtualUser.m
//  Project
//
//  Created by xuwen on 2018/7/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWVirtualUser.h"

@implementation XWVirtualUser

- (instancetype)initWithDict:(NSDictionary *)jsonDic
{
    self = [super init];
    if(self){
        NSString *photoStr = jsonDic[@"photo"];
        NSArray *imagenames = [photoStr componentsSeparatedByString:@","];
        self.userID = [NSString stringWithFormat:@"%@",jsonDic[@"userID"]];
        self.name = [NSString stringWithFormat:@"%@",jsonDic[@"name"]];
        self.imageName = [NSString stringWithFormat:@"%@",imagenames.firstObject];
        self.city = [NSString stringWithFormat:@"%@",jsonDic[@"city"]];
        self.age = [jsonDic[@"age"]intValue];
    }
    return self;
}

@end
