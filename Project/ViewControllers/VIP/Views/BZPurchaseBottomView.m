//
//  BZPurchaseBottomView.m
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZPurchaseBottomView.h"
#import "BZPurchaseHelper.h"
#import <RMStore/RMStore.h>

#import <AppsFlyerFramework/AppsFlyerLib/AppsFlyerTracker.h>
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAppEvents.h>

@interface BZPurchaseBottomView()
@property (nonatomic,strong) UIImageView *bottomImageView;
@property (nonatomic,strong) UILabel *bottomTitleLabel;

@property (nonatomic,strong) UIButton *buyButtonTop;

@property (nonatomic,strong) UIImageView *buyBottomImageView;
@property (nonatomic,strong) UILabel *freeLabel;
@property (nonatomic,strong) UILabel *yearPriceLabel;
@property (nonatomic,strong) UIButton *buyButtonBottom;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *privacyButton;
@property (nonatomic,strong) UIButton *termsButton;

@end

@implementation BZPurchaseBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
        [self baseConstraintConfig];
        [self priceConfig];
        [self observerConfig]; //价格加载变化后的监听
    }
    return self;
}

#pragma mark - observer
- (void)observerConfig
{
    [kUser addObserver:self forKeyPath:@"yearPrice" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"被修改的keyPath为：%@",keyPath);
    NSLog(@"被修改的对象为：%@",object);
    NSLog(@"被修改的上下文是：%@",context);
    NSLog(@"old : %@  new : %@",[change objectForKey:@"old"],[change objectForKey:@"new"]);
    if(kUser.yearPrice != 0){
        [self priceConfig];
    }
}

-(void)dealloc{
    [kUser removeObserver:self forKeyPath:@"yearPrice" context:nil];
}

#pragma mark - event
- (void)buyButtonTopClicked:(UIButton *)sender
{
    [self purchaseWithID:@"Weed_Subscription"];
}

- (void)buyButtonBottomClicked:(UIButton *)sender
{
     [self purchaseWithID:@"Year_Subscription"];
}

- (void)privacyButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLPrivacy;
    [self.eventVC.navigationController pushViewController:vc animated:YES];
}

- (void)userTermButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLTerms;
    [self.eventVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - privace
- (void)priceConfig
{
    [self.buyButtonTop setTitle:[[BZPurchaseHelper sharedBZPurchaseHelper]weekString] forState:UIControlStateNormal];
    self.freeLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]yearTopString];
    self.yearPriceLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]yearBottomString];
    self.textLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]purchaseDescpriptionSting];
}

- (void)purchaseWithID:(NSString *)productID
{
    //Weed_Subscription
    //Year_Subscription
    
    kXWWeakSelf(weakSelf);
    [self.eventVC showBZHUD];
    [[RMStore defaultStore]requestProducts:[NSSet setWithObject:productID] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        SKProduct *product = products.firstObject;
        CGFloat price = [product.price floatValue];
        [[RMStore defaultStore]addPayment:productID success:^(SKPaymentTransaction *transaction) {
            [weakSelf.eventVC hideBZHUD];
            [self purchaseAnalysis:price];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kISVIP];
            kUser.isVIP = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:APP_EVNET_PURCHASE_VIP object:nil];
            [weakSelf.eventVC.navigationController popToRootViewControllerAnimated:NO];
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            [weakSelf.eventVC hideBZHUD];
            NSLog(@"购买失败");
        }];
    } failure:^(NSError *error) {
        [weakSelf.eventVC hideBZHUD];
        NSLog(@"商品不存在");
    }];
}

- (void)purchaseAnalysis:(CGFloat)price
{
    //appflyer
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventPurchase withValues: @{  AFEventParamContentId:@"1234567",AFEventParamContentType : @"category_a",  AFEventParamRevenue:[NSNumber numberWithFloat:price*0.7] ,AFEventParamCurrency:@"USD"}];
    [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{ AFEventParamPrice: [NSNumber numberWithFloat:price*0.7] }];
    
    //google
    [FIRAnalytics logEventWithName:kFIREventAddPaymentInfo
                        parameters:@{
                                     kFIRParameterItemID:@"purchase",
                                     kFIRParameterValue : @(price*0.7),
                                     kFIRParameterCurrency : @"USD",
                                     }];
    //facebook
    [FBSDKAppEvents logPurchase:price*0.7 currency:@"USD"];
}


#pragma mark - baseConfig
- (void)baseUIConfig
{
    [self addSubview:self.bottomImageView];
    [self addSubview:self.bottomTitleLabel];
    [self addSubview:self.buyButtonTop];
    [self addSubview:self.buyBottomImageView];
    [self addSubview:self.freeLabel];
    [self addSubview:self.yearPriceLabel];
    [self addSubview:self.buyButtonBottom];
    [self addSubview:self.textLabel];
    [self addSubview:self.privacyButton];
    [self addSubview:self.termsButton];
}

- (void)baseConstraintConfig
{
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
    }];
    
    if(kUser.showWeekPurchase){
        [self.buyButtonTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@241);
            make.height.equalTo(@50);
            make.top.equalTo(self.bottomTitleLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self);
        }];
    }
    
    [self.buyBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@241);
        make.height.equalTo(@60);
        if(kUser.showWeekPurchase){
            make.top.equalTo(self.buyButtonTop.mas_bottom).offset(18);
        }else{
            make.top.equalTo(self.bottomTitleLabel.mas_bottom).offset(20);
        }
        make.centerX.equalTo(self);
    }];

    [self.freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(kUser.yearPurchaseShowDetail){
            make.bottom.equalTo(self.buyBottomImageView.mas_centerY).offset(-2);
        }else{
            make.bottom.equalTo(self.buyBottomImageView.mas_centerY).offset(4);
        }
        make.left.equalTo(self.buyBottomImageView).offset(10);
        make.right.equalTo(self.buyButtonBottom).offset(-10);
        make.height.equalTo(@20);
    }];
    [self.yearPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buyBottomImageView).offset(-15);
        make.left.equalTo(self.buyBottomImageView).offset(10);
        make.right.equalTo(self.buyButtonBottom).offset(-10);
        make.height.equalTo(@20);
    }];
    [self.buyButtonBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buyBottomImageView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyBottomImageView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(27);
        make.right.equalTo(self).offset(-27);
        make.bottom.equalTo(self.privacyButton.mas_top).offset(-30);
    }];
    [self.privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(self).offset(40);
        make.bottom.equalTo(self.self).offset(-30);
    }];
    [self.termsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.bottom.equalTo(self.self).offset(-30);
        make.right.equalTo(self).offset(-40);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)bottomImageView
{
    if(!_bottomImageView){
        _bottomImageView = [[UIImageView alloc]init];
        _bottomImageView.image = XWImageName(@"底部紫色");
        _bottomImageView.userInteractionEnabled = YES;
    }
    return _bottomImageView;
}

- (UILabel *)bottomTitleLabel
{
    if(!_bottomTitleLabel){
        _bottomTitleLabel = [[UILabel alloc]init];
        [_bottomTitleLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFang SC" size:14] aliment:NSTextAlignmentLeft];
        _bottomTitleLabel.numberOfLines = 0;
        _bottomTitleLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"Massive wallpapers waiting for you",nil),NSLocalizedString(@"Get updating wallpapers everyday",nil),NSLocalizedString(@"Immerse yourself in the fun of creating your own wallpapers",nil)];
        _bottomTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _bottomTitleLabel;
}

- (UIButton *)buyButtonTop
{
    if(!_buyButtonTop){
        _buyButtonTop = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButtonTop setBackgroundImage:XWImageName(@"矩形14") forState:UIControlStateNormal];
        [_buyButtonTop addTarget:self action:@selector(buyButtonTopClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buyButtonTop commonButtonConfigWithTitle:nil font:[UIFont fontWithName:@"PingFangSC-Semibol" size:15] titleColor:[UIColor xwColorWithHexString:@"#00CCEE"] aliment:UIControlContentHorizontalAlignmentCenter];
        _buyButtonTop.hidden = !kUser.showWeekPurchase;
    }
    return _buyButtonTop;
}

- (UIImageView *)buyBottomImageView
{
    if(!_buyBottomImageView){
        _buyBottomImageView = [[UIImageView alloc]init];
        _buyBottomImageView.image = XWImageName(@"组25");
        _buyBottomImageView.userInteractionEnabled = YES;
    }
    return _buyBottomImageView;
}

- (UILabel *)freeLabel
{
    if(!_freeLabel){
        _freeLabel = [[UILabel alloc]init];
        [_freeLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] aliment:NSTextAlignmentCenter];
        _freeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _freeLabel;
}

- (UILabel *)yearPriceLabel
{
    if(!_yearPriceLabel){
        _yearPriceLabel = [[UILabel alloc]init];
        [_yearPriceLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] aliment:NSTextAlignmentCenter];
        _yearPriceLabel.hidden = !kUser.yearPurchaseShowDetail;
        _yearPriceLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _yearPriceLabel;
}

- (UIButton *)buyButtonBottom
{
    if(!_buyButtonBottom){
        _buyButtonBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButtonBottom.backgroundColor = [UIColor clearColor];
        [_buyButtonBottom addTarget:self action:@selector(buyButtonBottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButtonBottom;
}

- (UILabel *)textLabel
{
    if(!_textLabel){
        _textLabel = [[UILabel alloc]init];
        [_textLabel commonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#F7F7F7"] font:[UIFont fontWithName:@"Helvetica" size:11] aliment:NSTextAlignmentCenter];
        //        _textLabel.hidden = YES;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIButton *)privacyButton
{
    if(!_privacyButton){
        _privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privacyButton commonButtonConfigWithTitle:NSLocalizedString(@"Privacy Policy",nil) font:[UIFont fontWithName:@"Helvetica" size:13] titleColor:[UIColor xwColorWithHexString:@"#F7F7F7"] aliment:0];
        [_privacyButton showBottomLineWithXSpace:0];
        [_privacyButton addTarget:self action:@selector(privacyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privacyButton;
}

- (UIButton *)termsButton
{
    if(!_termsButton){
        _termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_termsButton commonButtonConfigWithTitle:NSLocalizedString(@"Terms of Service",nil) font:[UIFont fontWithName:@"Helvetica" size:13] titleColor:[UIColor xwColorWithHexString:@"#F7F7F7"] aliment:0];
        [_termsButton showBottomLineWithXSpace:0];
        [_termsButton addTarget:self action:@selector(userTermButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _termsButton;
}


@end
