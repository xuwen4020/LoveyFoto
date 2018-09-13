//
//  BZDataTool.h
//  Project
//
//  Created by xuwen on 2018/9/4.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCPPlayerDataModel.h"

typedef void(^BZDataToolBlock)(BOOL isSuccess);

@interface BZDataTool : NSObject
SingletonH(BZDataTool)
//@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;

@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*homeRecommenceArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*homeLiveArray;

@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*hotRecommenceArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*hotAnimalArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*hotPeopleArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*hotXXXArray;

@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectNightArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectSummerArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectLoversArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectFoodArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectRuleArray;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*subjectAnimalArray;

@property (nonatomic,strong) NSArray *subjectArray;

- (void)dataConfigWithBlock:(BZDataToolBlock)block;


@end
