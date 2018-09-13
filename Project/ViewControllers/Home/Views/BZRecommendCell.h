//
//  BZRecommendCell.h
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZCollectionRecCell.h"

static NSString * const kBZRecommendCellIdentifier = @"BZRecommendCell";
@interface BZRecommendCell : UITableViewCell
@property (nonatomic,weak) BaseViewController *eventVC;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@end
