//
//  BZCollectionViewFlowLayout.h
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BZCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;

@end

@interface BZCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<BZCollectionViewFlowLayoutDelegate> delegate;
@end
