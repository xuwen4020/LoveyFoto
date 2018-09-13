//
//  BZRecommendCell.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZRecommendCell.h"
#import "XWBrowserView.h"
#import "UIImageView+WebCache.h"
#import "BZLiveVC.h"
#import "BZMoreVC.h"

@interface BZRecommendCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isLocked;
@end

@implementation BZRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
        [self notificationConfig];
    }
    return self;
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
}

- (void)baseConstraintsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vipChangedreload) name:APP_EVNET_PURCHASE_VIP object:nil];
}

- (void)vipChangedreload{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArray.count<5?self.dataArray.count:5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZCollectionRecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBZCollectionRecCellIdentifier forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:self.dataArray[indexPath.row].staticImageStr];
    [cell.bgImageView sd_setImageWithURL:url placeholderImage:XWImageName(@"placeholder")];
    cell.showMoreToVIP = indexPath.row == 4;
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCollectionRecCell_WIDTH, kCollectionRecCell_HEIGHT);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCollectionRecCell_EDGETOP, 15, kCollectionRecCell_EDGETOTTOM, 15); //上左下右
}

//这个是两行cell之间的间距（上下行cell的间距）区别于 ScrollDirection
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!kUser.isVIP && indexPath.row == 4){
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil];
        return;
    }
    
    if(kUser.isVIP && indexPath.row == 4){
        NSLog(@"showMore");
        BZMoreVC *vc = [[BZMoreVC alloc]init];
        vc.dataArray = self.dataArray;
        [self.eventVC.navigationController pushViewController:vc animated:nil];
        return;
    }
    
    if(!self.isLocked){
        self.isLocked = YES;
        BZCollectionRecCell *cell= (BZCollectionRecCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [XWBrowserView showFromImageView:cell.bgImageView withURLStrings:self.dataArray placeholderImage:XWImageName(@"") atIndex:indexPath.row parentView:self.eventVC.view category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
            self.isLocked = NO;
        }];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - setter & getter
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[BZCollectionRecCell class] forCellWithReuseIdentifier:kBZCollectionRecCellIdentifier];
    }
    return _collectionView;
}


- (void)setDataArray:(NSArray<LCPPlayerDataModel *> *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

@end
