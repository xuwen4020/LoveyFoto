//
//  BZMoreVC.m
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZMoreVC.h"
#import "BZCollectionRecCell.h"
#import "XWBrowserView.h"
#import "XWCollectManager.h"

#define kCell_WIDTH (kSCREEN_WIDTH - 40)/2.0
#define kCell_HEIGHT kCell_WIDTH/166*246

@interface BZMoreVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isLocked;
@end

@implementation BZMoreVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if(self.isCollection){
        self.dataArray = [[XWCollectManager sharedXWCollectManager] collectionArray];
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    
    [self commonViewControllerConfigWithTitle:self.isCollection?NSLocalizedString(@"My wallpapers", nil):NSLocalizedString(@"More", nil)];
    [self navBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)baseConstraintsConfig
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self.view showDefaultInView:collectionView isShow:self.dataArray.count == 0];
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZCollectionRecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBZCollectionRecCellIdentifier forIndexPath:indexPath];
    
    [cell xwDrawCornerWithRadiuce:8];
    [cell shadowColor:[UIColor lightGrayColor] opacity:0.3 offset:CGSizeMake(1, 1) radius:8];
    cell.showMoreToVIP = NO;
    return cell;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCell_WIDTH , kCell_HEIGHT);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
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
    if(!self.isLocked){
        self.isLocked = YES;
        BZCollectionRecCell *cell= (BZCollectionRecCell *)[collectionView cellForItemAtIndexPath:indexPath];
        kXWWeakSelf(weakSelf);
        [XWBrowserView showFromImageView:cell.bgImageView withURLStrings:self.dataArray placeholderImage:XWImageName(@"") atIndex:indexPath.row parentView:[[UIApplication sharedApplication] keyWindow] category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
            weakSelf.isLocked = NO;
            if(weakSelf.isCollection){
                weakSelf.dataArray = [[XWCollectManager sharedXWCollectManager] collectionArray];
                [weakSelf.collectionView reloadData];
            }
        }];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BZCollectionRecCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row].staticImageStr] placeholderImage:XWImageName(@"placeholder")];
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
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
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

@end
