//
//  LCPDataCenterManager.h
//  Dating Tonight
//
//  Created by 周杰的pro on 2017/11/21.
//  Copyright © 2017年 twsiturn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPDataCenterManager : NSObject

@property (nonatomic, strong) NSArray *live_newArray, *live_natureArray, *live_animalArray, *live_abstractArray, *hot_newArray, *hot_natureArray, *hot_animalArray, *hot_cityArray , *hot_peopleArray, *hot_abstractArray;
@property (nonatomic, strong) NSMutableArray *livePhotoArray;
@property (nonatomic, assign) BOOL pageSwitch;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) BOOL isApple;

+ (instancetype)defaultManager;

@end
