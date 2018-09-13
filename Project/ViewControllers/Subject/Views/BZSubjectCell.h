//
//  BZSubjectCell.h
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSubject_WIDTH kSCREEN_WIDTH - 30
#define kSubject_HEIGHT (kSubject_WIDTH)/345 * 145

static NSString *const kBZSubjectCellIdentifier = @"BZSubjectCell";
@interface BZSubjectCell : UITableViewCell
@property (nonatomic,strong) UIImageView *bgImageView;
@end
