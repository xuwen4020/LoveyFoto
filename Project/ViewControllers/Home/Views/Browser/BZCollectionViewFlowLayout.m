//
//  BZCollectionViewFlowLayout.m
//  Project
//
//  Created by xuwen on 2018/8/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCollectionViewFlowLayout.h"
#import "XWBrowserView.h"

@interface BZCollectionViewFlowLayout()
@property(nonatomic, assign) CGFloat lastProposedContentOffset;
@end

@implementation BZCollectionViewFlowLayout

-(instancetype)init
{
    if(self=[super init]){
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.minimumInteritemSpacing = 0.0f;
        
        self.sectionInset = UIEdgeInsetsZero;
        
        self.itemSize = CGSizeMake(kSCROLLWIDTH ,kSCROLLHEIGHT);
        
        self.minimumLineSpacing = 0;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 重写父类的方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    
    visibleRect.origin = self.collectionView.contentOffset;
    
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            
            if (visibleRect.origin.x == 0) {
                
                [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:0];
                
            }else{
                
                // 除法取整 取余数
                
                div_t x = div(visibleRect.origin.x,visibleRect.size.width);
                
                if (x.quot > 0 && x.rem > 0) {
                    
                    [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot + 1];
                    
                }
                
                if (x.quot > 0 && x.rem == 0) {
                    
                    [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:x.quot];
                    
                }
                
            }
            
        }
        
    }
    
    return attributes;
}

/*
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //1. 获取UICollectionView停止的时候的可视范围
    CGRect rangeFrame;
    rangeFrame.size = self.collectionView.frame.size;
    rangeFrame.origin = proposedContentOffset;
    
    NSArray *array = [self layoutAttributesForElementsInRect:rangeFrame];
    
    //2. 计算在可视范围的距离中心线最近的Item
    CGFloat minCenterX = CGFLOAT_MAX;
    CGFloat collectionCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionCenterX;
        }
    }
    
    //3. 补回ContentOffset，则正好将Item居中显示
    CGFloat proposedX = proposedContentOffset.x + minCenterX;
    // 滑动一屏时的偏移量
    CGFloat mainScreenBounds = [UIScreen mainScreen].bounds.size.width + 10;
    // 正向滑动仅滑动一屏
    if (proposedX - self.lastProposedContentOffset >= mainScreenBounds) {
        proposedX = mainScreenBounds + self.lastProposedContentOffset;
    }
    // 反向滑动仅滑动一屏
    if (proposedX - self.lastProposedContentOffset <= -mainScreenBounds) {
        proposedX = -mainScreenBounds + self.lastProposedContentOffset;
    }
    
    self.lastProposedContentOffset = proposedX;
    
    CGPoint finialProposedContentOffset = CGPointMake(proposedX, proposedContentOffset.y);
    return finialProposedContentOffset;
}
*/
@end
