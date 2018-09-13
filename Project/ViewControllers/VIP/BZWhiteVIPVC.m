//
//  BZWhiteVIPVC.m
//  Project
//
//  Created by xuwen on 2018/9/11.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZWhiteVIPVC.h"

#import "BZWhiteTopView.h"
#import "BZWhiteBottomView.h"
#import "BZWhiteVIPCancelVC.h"

@interface BZWhiteVIPVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic,strong) BZWhiteTopView *topView;
@property (nonatomic,strong) BZWhiteBottomView *bottomView;

//临时数据
@property (nonatomic,assign) BOOL isWeakPurchase;

@end

@implementation BZWhiteVIPVC
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XWHudView hideHud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

- (void)backButtonClicked:(UIButton *)sender
{
    BZWhiteVIPCancelVC *vc = [[BZWhiteVIPCancelVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - baseConfig

- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor clearColor];
    [self navBackButton];
    [self commonViewControllerConfigWithTitle:NSLocalizedString(@"Premium Access", nil)];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.contentImageView];

    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    
    [self.view addSubview:self.backButton];
}

- (void)baseConstraintsConfig
{
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.top.equalTo(self.view).offset(10+kStatusBarHeight-20);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@300);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.topView.mas_bottom);
    }];

}

#pragma mark - setter & getter
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIImageView *)contentImageView
{
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.image = XWImageName(@"图层30");
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}

- (UIButton *)backButton
{
    if(!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:XWImageName(@"白色叉") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        _backButton.hidden = (!kUser.isVIP && !kUser.isApple);
    }
    return _backButton;
}

- (BZWhiteTopView *)topView
{
    if(!_topView){
        _topView = [[BZWhiteTopView alloc]init];
        _topView.eventVC = self;
    }
    return _topView;
}

- (BZWhiteBottomView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[BZWhiteBottomView alloc]initWithFrame:CGRectZero isCancelView:NO];
        _bottomView.eventVC = self;
    }
    return _bottomView;
}

@end
