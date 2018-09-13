//
//  BZLoveCell.h
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBZLiveVC_WIDTH (kSCREEN_WIDTH - 45)/2
#define kBZLiveVC_HEIGHT kBZLiveVC_WIDTH/164*293

@class BZLiveVC;
static NSString *kBZLoveCellIdentifier = @"BZLoveCell";

@interface BZLoveCell : UITableViewCell
@property (nonatomic,strong) BZLiveVC *eventVC;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic,strong) UIImageView *imageViewLeft;
@property (nonatomic,strong) UIImageView *imageViewRight;
@property (nonatomic,assign) NSInteger leftIndex;
@property (nonatomic,assign) NSInteger rightIndex;
@end
