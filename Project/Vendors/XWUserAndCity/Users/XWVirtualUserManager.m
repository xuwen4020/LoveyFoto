//
//  XWVirtualUserManager.m
//  Project
//
//  Created by xuwen on 2018/7/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWVirtualUserManager.h"

@implementation XWVirtualUserManager
SingletonM(XWVirtualUserManager)
//获取虚拟用户
- (NSArray *)setVirtuarlUser
{
    //男生
    NSData *boy_JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"boys" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *boy_jsonDic = [NSJSONSerialization JSONObjectWithData:boy_JSONData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *boy_ary = boy_jsonDic[@"data"];
    NSMutableArray *mutabalArray = [NSMutableArray array];
    
    [boy_ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        XWVirtualUser *vituralUser = [[XWVirtualUser alloc]initWithDict:dic];
        vituralUser.gender = 1;  //男生是个棒
        [mutabalArray addObject:vituralUser];
    }];
    
    
    //女生
    NSData *girl_JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"girls" ofType:@"json"]];
    NSDictionary *girl_jsonDic = [NSJSONSerialization JSONObjectWithData:girl_JSONData options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *girl_ary = girl_jsonDic[@"data"];
    
    [girl_ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        XWVirtualUser *vituralUser = [[XWVirtualUser alloc]initWithDict:dic];
        vituralUser.gender = 0;  //女生是个孔
        [mutabalArray addObject:vituralUser];
    }];
    
    
    //打乱数组
    NSArray *array = [NSArray arrayWithArray:mutabalArray];
    [array sortedArrayUsingComparator:^NSComparisonResult(XWVirtualUser*  _Nonnull obj1, XWVirtualUser*  _Nonnull obj2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [obj1.name compare:obj2.name];
        } else {
            return [obj2.name compare:obj1.name];
        }
    }];
    return array;
}


//获取一个虚拟用户
- (XWVirtualUser *)getOneVirtuarlUser
{
    NSInteger index = arc4random_uniform(100);
    return [self setVirtuarlUser][index];
}

- (NSArray *)getVirturaUserCount:(int)count
{
    //男生
    NSData *boy_JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"boys" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *boy_jsonDic = [NSJSONSerialization JSONObjectWithData:boy_JSONData options:NSJSONReadingAllowFragments error:&error];
    NSMutableArray *boy_ary = boy_jsonDic[@"data"];
    NSMutableArray *boysArray = [NSMutableArray array];
    
    [boy_ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        XWVirtualUser *vituralUser = [[XWVirtualUser alloc]initWithDict:dic];
        vituralUser.gender = 1;  //男生是个棒
        [boysArray addObject:vituralUser];
    }];
    
    
    //女生
    NSData *girl_JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"girls" ofType:@"json"]];
    NSDictionary *girl_jsonDic = [NSJSONSerialization JSONObjectWithData:girl_JSONData options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *girl_ary = girl_jsonDic[@"data"];
    NSMutableArray *girlsArray = [NSMutableArray array];
    
    [girl_ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        XWVirtualUser *vituralUser = [[XWVirtualUser alloc]initWithDict:dic];
        vituralUser.gender = 0;  //女生是个孔
        [girlsArray addObject:vituralUser];
    }];
    
    NSMutableArray *lastArray = [NSMutableArray array];
    for(int i = 0;i<count;i++){
        if(i%2==0){
            [lastArray addObject:boysArray[i]];
        }else{
             [lastArray addObject:girlsArray[i]];
        }
    }
    
    return lastArray;
}

@end
