//
//  XWVirtualUser.h
//  Project
//
//  Created by xuwen on 2018/7/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWVirtualUser : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) int gender;
- (instancetype)initWithDict:(NSDictionary *)jsonDic;

@end
