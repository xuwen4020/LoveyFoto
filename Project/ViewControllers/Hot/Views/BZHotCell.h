//
//  BZHotCell.h
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHOT_CELL_WHIDE (kSCREEN_WIDTH - 30)/1.5
#define kHOT_CELL_HEIGHT kHOT_CELL_WHIDE*364.0/206.0

static NSString *const kBZHotCellIdentifier = @"BZHotCell";
@interface BZHotCell : UITableViewCell
@property (nonatomic,strong) UIViewController *eventVC;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@end
