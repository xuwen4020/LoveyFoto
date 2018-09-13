//
//  LCPDataCenterManager.m
//  Dating Tonight
//
//  Created by 周杰的pro on 2017/11/21.
//  Copyright © 2017年 twsiturn. All rights reserved.
//

#import "LCPDataCenterManager.h"

static LCPDataCenterManager *instance = nil;

@implementation LCPDataCenterManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
            instance.live_newArray = [[NSArray alloc] init];
            instance.live_natureArray = [[NSArray alloc] init];
            instance.live_animalArray = [[NSArray alloc] init];
            instance.live_abstractArray = [[NSArray alloc] init];
            instance.hot_newArray = [[NSArray alloc] init];
            instance.hot_natureArray = [[NSArray alloc] init];
            instance.hot_animalArray = [[NSArray alloc] init];
            instance.hot_cityArray = [[NSArray alloc] init];
            instance.hot_peopleArray = [[NSArray alloc] init];
            instance.hot_abstractArray = [[NSArray alloc] init];
            instance.livePhotoArray = [[NSMutableArray alloc] init];
        }
    });
    return instance;
}

@end
