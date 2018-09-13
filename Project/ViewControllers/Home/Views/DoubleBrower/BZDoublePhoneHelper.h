//
//  BZDoublePhoneHelper.h
//  Project
//
//  Created by xuwen on 2018/9/8.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BZDoublePhoneCell.h"

typedef void(^DoubleCollectionBlock)(BOOL isCollect);

@interface BZDoublePhoneHelper : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic,assign) BOOL showTimeEffect;
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) UIImageView *currentImageView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,copy) DoubleCollectionBlock collectBlock;

@property (nonatomic,strong) BZDoublePhoneCell *currentDoubleCell;
@end
