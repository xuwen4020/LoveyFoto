//
//  BZSubDetailCell.h
//  Project
//
//  Created by xuwen on 2018/8/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBZSubDetailCell_HEIGHT (kSCREEN_WIDTH - 70)/305*450+35
static NSString * const kBZSubDetailCellIdentifier = @"BZSubDetailCell";
@interface BZSubDetailCell : UITableViewCell
@property (nonatomic,strong) UIImageView *bgImageView;
@end
