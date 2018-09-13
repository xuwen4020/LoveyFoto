//
//  BZMainViewController.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZMainViewController.h"
#import "BZLiveVC.h"
#import "BZHotVC.h"
#import "BZSubjectVC.h"
#import "BZSettingVC.h"
#import "BZNewVIPVC.h"
#import "BZWhiteVIPVC.h"

#define kLineWidth kButtonWidth/2

@interface BZMainViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *buttonLive;
@property (nonatomic,strong) UIButton *buttonHot;
@property (nonatomic,strong) UIButton *buttonSubject;
@property (nonatomic,strong) UIButton *settingButton;
@property (nonatomic,strong) UIView *indexView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) BZLiveVC *liveVC;
@property (nonatomic,strong) BZHotVC *hotVC;
@property (nonatomic,strong) BZSubjectVC *subjectVC;

@end

@implementation BZMainViewController


#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    [self notificationConfig];
    
    //如果是用户状态,并且不是 VIP
    if(!kUser.isVIP && !kUser.isApple){
        if(kUser.showPurplePage){
            BZNewVIPVC *vc = [[BZNewVIPVC alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            BZWhiteVIPVC *vc = [[BZWhiteVIPVC alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }else{
//        [NSThread sleepForTimeInterval:1.0];
        [self animationConfig];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private
- (void)showPage:(NSInteger)page
{
    CGFloat x = page*kButtonWidth+(kButtonWidth-kLineWidth)/2.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.indexView.frame = CGRectMake(x, self.indexView.frame.origin.y, self.indexView.frame.size.width, self.indexView.frame.size.height);
    }];
    [self buttonChange:page];
}

- (void)buttonChange:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            self.buttonLive.selected = YES;
            self.buttonHot.selected = NO;
            self.buttonSubject.selected = NO;
        }
            break;
        case 1:
        {
            self.buttonLive.selected = NO;
            self.buttonHot.selected = YES;
            self.buttonSubject.selected = NO;
        }
            break;
        case 2:
        {
            self.buttonLive.selected = NO;
            self.buttonHot.selected = NO;
            self.buttonSubject.selected = YES;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.subjectVC loadDataReload];
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - event
- (void)buttonChooseClicked:(UIButton *)sender
{
    NSLog(@"页%ld",sender.tag);
    CGFloat x = sender.tag*kButtonWidth+(kButtonWidth-kLineWidth)/2.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.indexView.frame = CGRectMake(x, self.indexView.frame.origin.y, self.indexView.frame.size.width, self.indexView.frame.size.height);
    }];
    [self.scrollView scrollRectToVisible:CGRectMake(sender.tag*kSCREEN_WIDTH, 0,kSCREEN_WIDTH, 2.0) animated:YES];
    [self buttonChange:sender.tag];
}

- (void)settingButtonClicked:(UIButton *)button
{
    BZSettingVC *vc = [[BZSettingVC alloc]init];
    [self.navigationController pushViewController:vc animated:nil];
}

#pragma mark - baseConfig
- (void)animationConfig
{
    self.view.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:2.5 options:0 animations:^{
        self.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goVIP) name:APP_EVNET_GO_VIP object:nil];
}

- (void)goVIP
{
    if(kUser.showPurplePage){
        BZNewVIPVC *vc = [[BZNewVIPVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BZWhiteVIPVC *vc = [[BZWhiteVIPVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.liveVC.view];
    [self.contentView addSubview:self.hotVC.view];
    [self.contentView addSubview:self.subjectVC.view];
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.buttonLive];
    [self.topView addSubview:self.buttonHot];
    [self.topView addSubview:self.buttonSubject];
    [self.topView addSubview:self.indexView];
    [self.topView addSubview:self.settingButton];
}

- (void)baseConstraintsConfig
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@(kTOPHEIGHT));
    }];
    
    [self.buttonLive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kButtonWidth);
        make.height.equalTo(@18);
        make.left.equalTo(self.topView);
        make.bottom.equalTo(self.topView).offset(-22);
    }];
    [self.buttonHot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kButtonWidth);
        make.height.equalTo(@18);
        make.left.equalTo(self.buttonLive.mas_right);
        make.bottom.equalTo(self.topView).offset(-22);
    }];
    [self.buttonSubject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@kButtonWidth);
        make.height.equalTo(@18);
        make.left.equalTo(self.buttonHot.mas_right);
        make.bottom.equalTo(self.topView).offset(-22);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.buttonSubject);
        make.right.equalTo(self.topView).offset(-10);
//        make.bottom.equalTo(self.topView).offset(-22);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    [self.liveVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(0);
    }];
    [self.hotVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.liveVC.view.mas_right);
    }];
    [self.subjectVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.hotVC.view.mas_right);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subjectVC.view.mas_right);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/kSCREEN_WIDTH;
    CGFloat pageOff = scrollView.contentOffset.x/kSCREEN_WIDTH;
    NSInteger page = pageOff - currentPage > 0.5 ? currentPage + 1:currentPage;
    [self showPage:page];
}

#pragma mark - setter & getter
- (UIView *)topView
{
    if(!_topView){
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
        effectView.frame = CGRectMake(0,0,kSCREEN_WIDTH,kTOPHEIGHT);
        [self.view addSubview:effectView];
    }
    return _topView;
}

- (UIButton *)buttonLive
{
    if(!_buttonLive){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button commonButtonConfigWithTitle:NSLocalizedString(@"HOME", nil) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor projectMainTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xwColorWithHexString:@"#00CDE7"] forState:UIControlStateSelected];
        button.tag = 0;
        [button addTarget:self action:@selector(buttonChooseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _buttonLive = button;
        
        _buttonLive.selected = YES;
    }
    return _buttonLive;
}

- (UIButton *)buttonHot{
    if(!_buttonHot){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button commonButtonConfigWithTitle:NSLocalizedString(@"HOT", nil) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor projectMainTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xwColorWithHexString:@"#00CDE7"] forState:UIControlStateSelected];
        button.tag = 1;
        [button addTarget:self action:@selector(buttonChooseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _buttonHot = button;
    }
    return _buttonHot;
}

- (UIButton *)buttonSubject
{
    if(!_buttonSubject){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button commonButtonConfigWithTitle:NSLocalizedString(@"COLUMN", nil) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [button setTitleColor:[UIColor projectMainTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor xwColorWithHexString:@"#00CDE7"] forState:UIControlStateSelected];
        button.tag = 2;
        [button addTarget:self action:@selector(buttonChooseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _buttonSubject = button;
    }
    return _buttonSubject;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (BZLiveVC *)liveVC
{
    if(!_liveVC){
        _liveVC = [[BZLiveVC alloc]init];
        _liveVC.parentVC = self;
    }
    return _liveVC;
}

- (BZHotVC *)hotVC
{
    if(!_hotVC){
        _hotVC = [[BZHotVC alloc]init];
        _hotVC.parentVC = self;
    }
    return _hotVC;
}

- (BZSubjectVC *)subjectVC
{
    if(!_subjectVC){
        _subjectVC = [[BZSubjectVC alloc]init];
        _subjectVC.parentVC = self;
    }
    return _subjectVC;
}

- (UIView *)indexView
{
    if(!_indexView){
        _indexView = [[UIView alloc]init];
        _indexView.frame = CGRectMake((kButtonWidth-kLineWidth)/2.0, kTOPHEIGHT-5, kLineWidth, 5);
        [_indexView xwDrawCornerWithRadiuce:2.5];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor xwColorWithHexString:@"#00CCEE"].CGColor, (__bridge id)[UIColor xwColorWithHexString:@"#00D6B9"].CGColor];
        gradientLayer.locations = @[@0.0,@1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, kLineWidth, 5);
        [_indexView.layer addSublayer:gradientLayer];
    }
    return _indexView;
}

- (UIButton *)settingButton
{
    if(!_settingButton){
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:XWImageName(@"设置") forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

@end
