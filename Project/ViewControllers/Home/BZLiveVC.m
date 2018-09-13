//
//  BZLiveVC.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZLiveVC.h"
#import "SDCycleScrollView.h"
#import "BZRecommendCell.h"
#import "BZLoveCell.h"
#import "XWBrowserView.h"
#import "MJRefresh.h"
#import "XWDoubleBrowerView.h"
#import "BZSubDetailVC.h"

#define kBannerHeight kSCREEN_WIDTH/375*157

@interface BZLiveVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *bannerDataArray;  //banner 数据

@end

@implementation BZLiveVC
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    [self notificationConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event
- (void)loadNewData
{
    [self.mainTableView.mj_header beginRefreshing];
    kXWWeakSelf(weakSelf);
    [[BZDataTool sharedBZDataTool]dataConfigWithBlock:^(BOOL isSuccess) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.mainTableView.mj_header endRefreshing];
            [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_UPLOAD_DATA object:nil];
        });
    }];
}

- (void)vipClicked
{
    [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

- (void)baseConstraintsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(kUser.isVIP){
            make.edges.equalTo(self.view);
        }else{
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(100);
        }
    }];
}

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vipChangedreload) name:APP_EVNET_PURCHASE_VIP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataReload) name:APP_EVNET_UPLOAD_DATA object:nil];
}

- (void)vipChangedreload{
    [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.mainTableView reloadData];
}

- (void)loadDataReload
{
    [self.mainTableView reloadData];
    [self bannerDataConfig];
}

- (void)bannerDataConfig
{
    NSArray *array = [BZDataTool sharedBZDataTool].subjectArray;
    NSMutableArray *imageURLArray = [NSMutableArray array];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[BZDataTool sharedBZDataTool].subjectArray];
    NSLog(@"%@",mutableArray);
    self.bannerDataArray = [NSMutableArray array];
    for(int i = 0;i<4;i++){
        NSUInteger random = arc4random() % (mutableArray.count);
        [self.bannerDataArray addObject:mutableArray[random]];
        [mutableArray removeObjectAtIndex:random];
    }
    for(NSArray <LCPPlayerDataModel *>*array in self.bannerDataArray){
        LCPPlayerDataModel *model = array.firstObject;
        [imageURLArray addObject:model.staticImageStr];
    }
    self.bannerScrollView.imageURLStringsGroup = imageURLArray;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(kUser.isVIP){
        NSArray <LCPPlayerDataModel *>*array = self.bannerDataArray[index];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
        if(mutableArray > 0){
            [mutableArray removeObjectAtIndex:0];
        }
        BZSubDetailVC *vc = [[BZSubDetailVC alloc]init];
        vc.dataArray = mutableArray;
        [self.parentVC.navigationController pushViewController:vc animated:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_GO_VIP object:nil userInfo:nil];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        if(kUser.isVIP){
            return [BZDataTool sharedBZDataTool].homeLiveArray.count/2;
        }else{
            NSInteger count = [BZDataTool sharedBZDataTool].homeLiveArray.count/2;
            count = count<4?count:4;
            return count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        BZRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kBZRecommendCellIdentifier forIndexPath:indexPath];
        cell.eventVC = self.parentVC;
        cell.dataArray = [BZDataTool sharedBZDataTool].homeRecommenceArray;
        return cell;
    }else{
        BZLoveCell *cell = [tableView dequeueReusableCellWithIdentifier:kBZLoveCellIdentifier forIndexPath:indexPath];
        cell.eventVC = self;
        cell.dataArray = [BZDataTool sharedBZDataTool].homeLiveArray;
        NSURL *leftURL = [NSURL URLWithString:[BZDataTool sharedBZDataTool].homeLiveArray[indexPath.row*2].staticImageStr];
        NSURL *rightURL = [NSURL URLWithString:[BZDataTool sharedBZDataTool].homeLiveArray[indexPath.row*2+1].staticImageStr];
        [cell.imageViewLeft sd_setImageWithURL:leftURL placeholderImage:XWImageName(@"placeholder")];
        [cell.imageViewRight sd_setImageWithURL:rightURL placeholderImage:XWImageName(@"placeholder")];
        cell.leftIndex = indexPath.row*2;
        cell.rightIndex = indexPath.row*2+1;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return kCollectionRecCell_HEIGHT+kCollectionRecCell_EDGETOP+kCollectionRecCell_EDGETOTTOM;
    }else{
        NSLog(@"%f",kBZLiveVC_HEIGHT + 15 * 2);
        return kBZLiveVC_HEIGHT + 15 * 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return 33.0;
    }
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[NSLocalizedString(@"RECOMMEND", nil),NSLocalizedString(@"LOVE", nil)];
    UIView *headView = [[UIView alloc]init];
    [headView xwDrawCornerWithRadiuce:0];
    
    UILabel *headLabel = [[UILabel alloc]init];
    [headLabel commonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] aliment:NSTextAlignmentLeft];
    headLabel.text = array[section];
    
    UIView *lineView = [[UIView alloc]init];
    [lineView xwDrawCornerWithRadiuce:2.5];
    lineView.backgroundColor = [UIColor xwColorWithHexString:@"#00CEEC"];
    
    [headView addSubview:headLabel];
    [headView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.centerY.equalTo(headLabel);
        make.width.equalTo(@5);
        make.height.equalTo(@20);
    }];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(8);
        make.bottom.equalTo(headView).offset(-15);
        make.height.equalTo(@14);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1){
        return kUser.isVIP?0.0001:kSCREEN_WIDTH/750*536;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1 && !kUser.isVIP){
        UIView *footerView = [[UIView alloc]init];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:XWImageName(@"图层526")];
        imageView.userInteractionEnabled = YES;
        
        UILabel *Label = [[UILabel alloc]init];
        [Label commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:18] aliment:NSTextAlignmentCenter];
        Label.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        Label.text = NSLocalizedString(@"Update! View more wallpapers", nil);
        Label.adjustsFontSizeToFitWidth = YES;
        [Label xwDrawCornerWithRadiuce:18];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button commonButtonConfigWithTitle:NSLocalizedString(@"Update! View more wallpapers", nil) font:[UIFont fontWithName:@"PingFangSC-Medium" size:18] titleColor:[UIColor whiteColor] aliment:UIControlContentHorizontalAlignmentCenter];
        button.backgroundColor = [UIColor clearColor];
        [button xwDrawCornerWithRadiuce:18];
        [button addTarget:self action:@selector(vipClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:imageView];
        [footerView addSubview:Label];
        [footerView addSubview:button];
        
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(button);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView);
        }];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(35);
            make.right.equalTo(footerView).offset(-35);
            make.height.equalTo(@63);
            make.bottom.equalTo(footerView).offset(-138);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClicked)];
        [tap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:tap];
        
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section != 0){
//        BZLoveCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        [XWDoubleBrowerView showFromImageView:cell.imageViewLeft andImageView:cell.imageViewRight withURLStrings:nil placeholderImage:nil atIndex:1 parentView:[[UIApplication sharedApplication] keyWindow] category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
//            
//        }];
//    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - setter & getter
- (UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_mainTableView commonTableViewConfig];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.bannerScrollView;
        [_mainTableView registerClass:[BZRecommendCell class] forCellReuseIdentifier:kBZRecommendCellIdentifier];
        [_mainTableView registerClass:[BZLoveCell class] forCellReuseIdentifier:kBZLoveCellIdentifier];
        
        //MJRefresh
         MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0;i<136;i++){
            NSString *str =  [NSString stringWithFormat:@"19_dark_00%03d",i];
            [array addObject:XWImageName(str)];
        }
        [header setImages:array forState:MJRefreshStatePulling];
        [header setImages:array duration:2.0 forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _mainTableView.mj_header = header;
        _mainTableView.mj_header.automaticallyChangeAlpha = YES;
        
    }
    return _mainTableView;
}

- (SDCycleScrollView *)bannerScrollView
{
    if (!_bannerScrollView) {
        _bannerScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kBannerHeight)];
        _bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
         _bannerScrollView.localizationImageNamesGroup = @[@"2019",@"2019",@"2019"];
        _bannerScrollView.autoScrollTimeInterval = 5.;
        _bannerScrollView.delegate = self;
        _bannerScrollView.showPageControl = NO;
//        [self bannerDataConfig];
    }
    return _bannerScrollView;
}

//- (void)setDataArray:(NSArray<LCPPlayerDataModel *> *)dataArray
//{
//    _dataArray = dataArray;
//    [self.mainTableView reloadData];
//}

@end
