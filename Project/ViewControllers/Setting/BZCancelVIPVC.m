//
//  BZCancelVIPVC.m
//  Project
//
//  Created by xuwen on 2018/9/11.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCancelVIPVC.h"

@interface BZCancelVIPVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation BZCancelVIPVC

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    self.view.backgroundColor = [UIColor yellowColor];
    [self navBackButton];
    [self commonViewControllerConfigWithTitle:@""];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentImageView];
    [self.scrollView addSubview:self.contentView];
}

- (void)baseConstraintsConfig
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.width.equalTo(@(0));
        make.centerX.equalTo(self.scrollView);
        make.height.mas_equalTo(kSCREEN_WIDTH/750*3752);
        make.bottom.equalTo(self.contentImageView);
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
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIImageView *)contentImageView
{
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc]init];
        _contentImageView.image = XWImageName(@"取消续订");
    }
    return _contentImageView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}


@end
