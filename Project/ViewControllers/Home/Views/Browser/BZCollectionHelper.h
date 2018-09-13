//
//  BZCollectionHelper.h
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CollectionBlock)(BOOL isCollect);

@interface BZCollectionHelper : NSObject <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic,assign) BOOL showTimeEffect;

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) UIImageView *currentImageView;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,copy) CollectionBlock collectBlock;

- (void)removeCurrentPlayer;
@end
