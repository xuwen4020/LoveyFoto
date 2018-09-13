//
//  BZDataTool.m
//  Project
//
//  Created by xuwen on 2018/9/4.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZDataTool.h"

@interface BZDataTool()
@property (nonatomic,copy) BZDataToolBlock block;
@end

@implementation BZDataTool
SingletonM(BZDataTool)

- (void)dataConfigWithBlock:(BZDataToolBlock)block
{
    self.block = block;
    
    [LCPHTTPRequestManager getWithPathUrl:@"https://s3-us-west-2.amazonaws.com/datingmenow/love_wallpaper/config.json" parameters:nil success:^(BOOL success, id JSON) {
        
        //首页
        NSDictionary *homeDict = [JSON objectForKey:@"Home"];
        NSDictionary *home_Recommence = homeDict[@"Recommend"];
        NSDictionary *home_Live = homeDict[@"Love"];
        self.homeRecommenceArray = [NSArray arrayWithArray:[self modelForDictionary:home_Recommence]];
        self.homeLiveArray = [NSArray arrayWithArray:[self modelForDictionary:home_Live]];
        
        //热门
        NSDictionary *hotDict = [JSON objectForKey:@"Hot"];
        NSDictionary *hot_recommenceDict = hotDict[@"Recommence"];
        NSDictionary *hot_PeopleDict = hotDict[@"People"];
        NSDictionary *hot_AnimalDict = hotDict[@"Animal"];
        NSDictionary *hot_XXXDict = hotDict[@"XXX"];
        self.hotRecommenceArray = [NSArray arrayWithArray:[self modelForDictionary:hot_recommenceDict]];
        self.hotPeopleArray = [NSArray arrayWithArray:[self modelForDictionary:hot_PeopleDict]];
        self.hotAnimalArray = [NSArray arrayWithArray:[self modelForDictionary:hot_AnimalDict]];
        self.hotXXXArray = [NSArray arrayWithArray:[self modelForDictionary:hot_XXXDict]];
        
        //专题
        NSMutableArray *mutableArray = [NSMutableArray array];
        NSDictionary *subjectDict = [JSON objectForKey:@"Subject"];
        NSArray *keyArray = [subjectDict allKeys];
        
        //排序
        NSMutableArray *sortArray = [NSMutableArray arrayWithArray:keyArray];
        [sortArray sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            if([obj1 integerValue] >= [obj2 integerValue])
            {
                return NSOrderedDescending;
            }else
            {
                return NSOrderedAscending;
            }
        }];
        
        for(NSString *key in sortArray){
            NSArray *array = [self modelForDictionary:subjectDict[key]];
            [mutableArray addObject:array];
        }
        self.subjectArray = [NSArray arrayWithArray:mutableArray];
        
        if(self.block){
            self.block(YES);
        }
        NSLog(@"☯️☯️☯️☯️☯️☯️☯️☯️\n%@",JSON);
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"☯️☯️☯️☯️☯️☯️☯️☯️\n%@",error);
    }];
}

- (NSArray *)modelForDictionary:(NSDictionary *)dict
{
    int min = [[dict valueForKey:@"min"] intValue];
    int max = [[dict valueForKey:@"max"] intValue];
    NSString *url = [dict valueForKey:@"url"];
    NSString *photo_extension = [dict valueForKey:@"photo_extension"];
    NSString *mov_extension = [dict valueForKey:@"mov_extension"];
    
    NSMutableArray *reArray = [[NSMutableArray alloc] init];
    for (int i = max; i >= min; i--) {
        LCPPlayerDataModel *model = [[LCPPlayerDataModel alloc]init];
        model.staticImageStr = [NSString stringWithFormat:@"%@%d%@",url, i, photo_extension];
        model.dynamicVedioStr = [NSString stringWithFormat:@"%@%d%@",url, i, mov_extension];
        [reArray addObject:model];
    }

    return reArray;
}
@end
