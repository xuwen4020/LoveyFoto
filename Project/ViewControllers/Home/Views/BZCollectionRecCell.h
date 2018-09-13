//
//  BZCollectionRecCell.h
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCollectionRecCell_EDGETOP 0
#define kCollectionRecCell_EDGETOTTOM 20
#define kCollectionRecCell_EDGELEFT 15
#define kCollectionRecCell_WIDTH (kSCREEN_WIDTH-kCollectionRecCell_EDGELEFT*3)/2.5
#define kCollectionRecCell_HEIGHT (kCollectionRecCell_WIDTH)/119*210

static NSString *const kBZCollectionRecCellIdentifier = @"BZCollectionRecCell";
@interface BZCollectionRecCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,assign) BOOL showMoreToVIP;
@end
