//
//  BZSubDetailVC.m
//  Project
//
//  Created by xuwen on 2018/8/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSubDetailVC.h"
#import "BZSubDetailCell.h"
#import "XWBrowserView.h"

@interface BZSubDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,assign) BOOL isLocked;
@end

@implementation BZSubDetailVC

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
    [self commonViewControllerConfigWithTitle:NSLocalizedString(@"COLUMN", nil)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navBackButton];
    [self.view addSubview:self.mainTableView];
}

- (void)baseConstraintsConfig
{
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZSubDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBZSubDetailCellIdentifier forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:self.dataArray[indexPath.row].staticImageStr];
    [cell.bgImageView sd_setImageWithURL:url placeholderImage:XWImageName(@"placeholder")];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBZSubDetailCell_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return kSCREEN_WIDTH/375*145;
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *view = [[UIView alloc]init];
//    [view addSubview:self.headImageView];
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(view);
//    }];
//    return view;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return kUser.isVIP?0.0001:100.0;
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if(!kUser.isVIP){
//        UIView *footerView = [[UIView alloc]init];
//        UILabel *label = [[UILabel alloc]init];
//        [label commonLabelConfigWithTextColor:[UIColor projectMainTextColor] font:Font(15) aliment:NSTextAlignmentCenter];
//        [footerView addSubview:label];
//        label.text = @"升级 VIP";
//        [label xwDrawCornerWithRadiuce:8];
//        label.backgroundColor = [UIColor lightGrayColor];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(footerView).offset(10);
//            make.right.equalTo(footerView).offset(-10);
//            make.top.equalTo(footerView).offset(10);
//            make.bottom.equalTo(footerView).offset(-10);
//        }];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipClicked)];
//        [tap setNumberOfTapsRequired:1];
//        [footerView addGestureRecognizer:tap];
//
//        return footerView;
//    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isLocked){
        self.isLocked = YES;
        BZSubDetailCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [XWBrowserView showFromImageView:cell.bgImageView withURLStrings:self.dataArray placeholderImage:XWImageName(@"") atIndex:indexPath.row parentView:[[UIApplication sharedApplication] keyWindow] category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
            self.isLocked = NO;
        }];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull BZSubDetailCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:self.dataArray[indexPath.row].staticImageStr];
    [cell.bgImageView sd_setImageWithURL:url placeholderImage:XWImageName(@"placeholder")];
    
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
        [_mainTableView registerClass:[BZSubDetailCell class] forCellReuseIdentifier:kBZSubDetailCellIdentifier];
    }
    return _mainTableView;
}

- (UIImageView *)headImageView
{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image = XWImageName(@"NightTheme");
    }
    return _headImageView;
}

- (void)setDataArray:(NSArray<LCPPlayerDataModel *> *)dataArray
{
    _dataArray = dataArray;
    [self.mainTableView reloadData];
}
@end
