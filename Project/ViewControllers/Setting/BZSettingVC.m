//
//  BZSettingVC.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSettingVC.h"
#import <RMStore/RMStore.h>
#import "XWMessageAlertView.h"
#import "BZMoreVC.h"
#import "XWCollectManager.h"
#import "XWHTMLViewController.h"
#import "BZCashTool.h"
#import "QSPDownloadTool.h"
#import "BZSettingButton.h"
#import "BZCancelVIPVC.h"

#define kPhontStartFrame CGRectMake(kSCREEN_WIDTH-233, -407, 321, 407)
#define kPhontEndFrame CGRectMake(kSCREEN_WIDTH-233, 46+kStatusBarHeight, 321, 407)


@interface BZSettingVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *PhoneImageView;

@property (nonatomic,strong) UIImageView *pullImageView;

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UILabel *titleLabel;  //关于我们
@property (nonatomic,strong) UILabel *aboutLabel;  //关于 LOVE 壁纸
@property (nonatomic,strong) UILabel *descriptionLabel;

@property (nonatomic,strong) BZSettingButton *collectionButton;
@property (nonatomic,strong) BZSettingButton *restoreButton;
@property (nonatomic,strong) BZSettingButton *userTermButton;
@property (nonatomic,strong) BZSettingButton *privacyButton;
@property (nonatomic,strong) BZSettingButton *cancelButton;
@property (nonatomic,strong) BZSettingButton *suggestionButton;

@end

@implementation BZSettingVC

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    [self animationConfig];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event
- (void)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:nil];
}

// 恢复内购
- (void)restoreButtonClicked:(UIButton *)sender
{
    [XWHudView showHUD];
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
        [XWHudView hideHUD];
        if(transactions.count == 0){
            [XWMessageAlertView showSuccess:NSLocalizedString(@"Recover purchase Fail", nil) block:nil];
            return ;
        }
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kISVIP];
        kUser.isVIP = YES;
        [XWMessageAlertView showSuccess:NSLocalizedString(@"Recover purchase Success", nil) block:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_PURCHASE_VIP object:nil];
    } failure:^(NSError *error) {
        [XWHudView hideHUD];
        [XWMessageAlertView showSuccess:NSLocalizedString(@"Recover purchase Fail", nil) block:nil];
    }];
}

//收藏
- (void)collectionButtonClicked:(UIButton *)sender
{
    BZMoreVC *vc = [[BZMoreVC alloc]init];
    vc.isCollection = YES;
    [self.navigationController pushViewController:vc animated:nil];
}

//反馈意见
- (void)suggestingButtongClicked:(UIButton *)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto:LoveyFoto_Service@outlook.com"]];
}

//隐私协议
- (void)privacyButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLPrivacy;
    [self.navigationController pushViewController:vc animated:YES];
}

//用户协议
- (void)userTermButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLTerms;
    [self.navigationController pushViewController:vc animated:YES];
}

//取消内购
- (void)cancelButtonClicked:(UIButton *)sender
{
    BZCancelVIPVC *vc = [[BZCancelVIPVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.view.backgroundColor = [UIColor xwColorWithHexString:@"3c3c8c"];
    [self navBackButton];
    [self commonViewControllerConfigWithTitle:@"VIP"];
    [self.view addSubview:self.pullImageView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentImageView];
    [self.scrollView addSubview:self.contentView];
    
    [self.view addSubview:self.backButton];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.aboutLabel];
    [self.contentView addSubview:self.descriptionLabel];
    
    [self.contentView addSubview:self.collectionButton];
    [self.contentView addSubview:self.restoreButton];
    [self.contentView addSubview:self.userTermButton];
    [self.contentView addSubview:self.privacyButton];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.suggestionButton];
}

- (void)baseConstraintsConfig
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
    }];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.width.equalTo(@(kSCREEN_WIDTH));
        make.centerX.equalTo(self.scrollView);
        make.height.mas_equalTo(1050+kSafeAreaBottomHeight+kStatusBarHeight);
        make.bottom.equalTo(self.contentImageView);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.top.equalTo(@(kStatusBarHeight));
        make.left.equalTo(self.view).offset(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.backButton);
        make.top.equalTo(self.contentView).offset(kStatusBarHeight+10);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
    }];
    [self.aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.contentView).offset(284+kStatusBarHeight-20);
        make.height.equalTo(@(30));
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.top.equalTo(self.aboutLabel.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-21);
    }];
    
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(64);
    }];
    
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.collectionButton).offset(70);
    }];
    
    [self.userTermButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.restoreButton).offset(70);
    }];
    [self.privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.userTermButton).offset(70);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.privacyButton).offset(70);
    }];
    [self.suggestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(21);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-21);
        make.top.equalTo(self.cancelButton).offset(70);
    }];
}

- (void)animationConfig
{
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.PhoneImageView.frame = kPhontEndFrame;
    } completion:^(BOOL finished) {
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            CGRect frame1 = CGRectMake(-100, self.collectionButton.top, self.collectionButton.width, self.collectionButton.height);
//            self.collectionButton.frame = frame1;
//            [UIView animateWithDuration:0.5 animations:^{
//                self.collectionButton.frame = CGRectMake(21,self.collectionButton.top, self.collectionButton.width, self.collectionButton.height);
//            } completion:^(BOOL finished) {
//
//            }];
//
//
//        });
        
    }];
}

#pragma mark - setter & getter
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIImageView *)contentImageView
{
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc]init];
//        _contentImageView.image = XWImageName(@"图层30");
        _contentImageView.backgroundColor = [UIColor xwColorWithHexString:@"3c3c8c"];
        [_contentImageView addSubview:self.topImageView];
        [_contentImageView addSubview:self.PhoneImageView];
        [_contentImageView addSubview:self.centerImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_contentImageView);
            make.height.equalTo(@(332+kStatusBarHeight-20));
        }];
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentImageView);
            make.top.equalTo(self.topImageView.mas_bottom);
            make.height.equalTo(@170);
        }];
    }
    return _contentImageView;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIImageView *)topImageView
{
    if(!_topImageView){
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = XWImageName(@"图层46");
    }
    return _topImageView;
}

- (UIImageView *)PhoneImageView
{
    if(!_PhoneImageView){
        _PhoneImageView = [[UIImageView alloc]initWithImage:XWImageName(@"图层33")];
        _PhoneImageView.frame = kPhontStartFrame;
    }
    return _PhoneImageView;
}

- (UIImageView *)centerImageView
{
    if(!_centerImageView){
        _centerImageView = [[UIImageView alloc]initWithImage:XWImageName(@"图层45")];
    }
    return _centerImageView;
}

- (UIButton *)backButton
{
    if(!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:XWImageName(@"返回白") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:24] aliment:NSTextAlignmentCenter];
        _titleLabel.text = NSLocalizedString(@"About us", nil);
    }
    return _titleLabel;
}

- (UILabel *)aboutLabel
{
    if(!_aboutLabel){
        _aboutLabel = [[UILabel alloc]init];
        [_aboutLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:28] aliment:NSTextAlignmentLeft];
        _aboutLabel.text = NSLocalizedString(@"About Lovey Foto", nil);
        _aboutLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _aboutLabel;
}

- (UILabel *)descriptionLabel
{
    if(!_descriptionLabel){
        _descriptionLabel = [[UILabel alloc]init];
        [_descriptionLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] aliment:NSTextAlignmentLeft];
        _descriptionLabel.numberOfLines = 0;
        NSString *text = NSLocalizedString(@"We carefully select some very suitable couple wallpapers for you every week, I hope you will not worry about taking up your mobile phone memory because of the frequent use of our app. We will automatically clean up when it caches to 200M.", nil);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        [_descriptionLabel setAttributedText:attributedString1];
        [_descriptionLabel sizeToFit];
    }
    return _descriptionLabel;
}


- (BZSettingButton *)collectionButton
{
    if(!_collectionButton){
        _collectionButton = [[BZSettingButton alloc]initWithText:NSLocalizedString(@"My wallpapers",nil) Target:self action:@selector(collectionButtonClicked:)];
    }
    return _collectionButton;
}

- (BZSettingButton *)restoreButton
{
    if(!_restoreButton){
        _restoreButton = [[BZSettingButton alloc]initWithText:NSLocalizedString(@"Recover purchase in-app",nil) Target:self action:@selector(restoreButtonClicked:)];
    }
    return _restoreButton;
}

- (BZSettingButton *)userTermButton
{
    if(!_userTermButton){
        _userTermButton = [[BZSettingButton alloc]initWithText:NSLocalizedString(@"Terms of Service",nil) Target:self action:@selector(userTermButtonClicked:)];
    }
    return _userTermButton;
}

- (BZSettingButton *)privacyButton
{
    if(!_privacyButton){
        _privacyButton =  [[BZSettingButton alloc]initWithText:NSLocalizedString(@"Privacy Policy",nil) Target:self action:@selector(privacyButtonClicked:)];
    }
    return _privacyButton;
}

- (BZSettingButton *)cancelButton
{
    if(!_cancelButton){
        _cancelButton = [[BZSettingButton alloc]initWithText:NSLocalizedString(@"How to cancel renewal",nil) Target:self action:@selector(cancelButtonClicked:)];
    }
    return _cancelButton;
}

- (BZSettingButton *)suggestionButton
{
    if(!_suggestionButton){
        _suggestionButton = [[BZSettingButton alloc]initWithText:NSLocalizedString(@"Suggestions",nil) Target:self action:@selector(suggestingButtongClicked:)];
    }
    
    return _suggestionButton;
}

- (UIImageView *)pullImageView
{
    if(!_pullImageView){
        _pullImageView = [[UIImageView alloc]init];
        _pullImageView.image = XWImageName(@"pullImage");
        _pullImageView.frame = CGRectMake(0, -kSCREEN_HEIGHT/2, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    return _pullImageView;
}



@end
