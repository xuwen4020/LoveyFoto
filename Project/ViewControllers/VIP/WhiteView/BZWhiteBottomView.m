//
//  BZWhiteBottomView.m
//  Project
//
//  Created by xuwen on 2018/9/13.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZWhiteBottomView.h"
#import "BZPurchaseHelper.h"
#import <RMStore/RMStore.h>

#import <AppsFlyerFramework/AppsFlyerLib/AppsFlyerTracker.h>
#import <Firebase/Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKAppEvents.h>

@interface BZWhiteBottomView()
@property (nonatomic,strong) UIImageView *bottomImageView;

@property (nonatomic,strong) UIImageView *imageView3;

@property (nonatomic,strong) UIView *textView;
@property (nonatomic,strong) UILabel *line1Label;
@property (nonatomic,strong) UILabel *line2Label;
@property (nonatomic,strong) UILabel *line4Label;
@property (nonatomic,strong) UIImageView *line1ImageView;
@property (nonatomic,strong) UIImageView *line2ImageView;
@property (nonatomic,strong) UIImageView *line4ImageView;


@property (nonatomic,strong) UIImageView *buyBottomImageView;
@property (nonatomic,strong) UILabel *freeLabel;
@property (nonatomic,strong) UIButton *buyButtonBottom;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *privacyButton;
@property (nonatomic,strong) UIButton *termsButton;

@property (nonatomic,assign) BOOL isWeakPurchase;

@property (nonatomic,assign) BOOL isCancel;

@end

@implementation BZWhiteBottomView

- (instancetype)initWithFrame:(CGRect)frame isCancelView:(BOOL)cancelView
{
    self = [super initWithFrame:frame];
    if(self){
        self.isCancel = cancelView;
        [self baseUIConfig];
        [self baseConstraintConfig];
        [self priceConfig];
        [self observerConfig]; //价格加载变化后的监听
        [self notificationConfig];
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
- (void)priceConfig
{
    self.textLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]purchaseDescpriptionSting];
}

-(void)dealloc{
    [kUser removeObserver:self forKeyPath:@"yearPrice" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event
//隐私协议
- (void)privacyButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLPrivacy;
    [self.eventVC.navigationController pushViewController:vc animated:YES];
}

//用户协议
- (void)userTermButtonClicked:(UIButton *)sender
{
    XWHTMLViewController *vc = [[XWHTMLViewController alloc]init];
    vc.style = XWHTMLTerms;
    [self.eventVC.navigationController pushViewController:vc animated:YES];
}

- (void)buyButtonBottomClicked:(UIButton *)sender
{
    if(self.isWeakPurchase){
        [self purchaseWithID:@"Weed_Subscription"];
    }else{
        [self purchaseWithID:@"Year_Subscription"];
    }
}

#pragma mark - privace

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
    
    if(self.isCancel){
        [self addSubview:self.textView];
    }else{
        [self addSubview:self.imageView3];
    }
    
    [self addSubview:self.buyBottomImageView];
    [self.buyBottomImageView addSubview:self.freeLabel];
    [self.buyBottomImageView addSubview:self.buyButtonBottom];

    [self addSubview:self.textLabel];
    [self addSubview:self.termsButton];
    [self addSubview:self.privacyButton];
}

- (void)baseConstraintConfig
{
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if(self.isCancel){
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(self);
        }];
    }
    else{
        [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self);
            make.height.equalTo(@(kSCREEN_WIDTH/375*248));
        }];
    }
    
    [self.buyBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.isCancel){
            make.top.equalTo(self.textView.mas_bottom).offset(30);
        }else{
            make.top.equalTo(self.imageView3.mas_bottom).offset(30);
        }
        make.width.equalTo(@310);
        make.height.equalTo(@75);
        make.bottom.equalTo(self.textLabel.mas_top).offset(-13);
        make.centerX.equalTo(self);
    }];
    
    [self.buyButtonBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buyBottomImageView);
    }];
    [self.freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buyBottomImageView);
        make.bottom.equalTo(self.buyBottomImageView.mas_centerY).offset(0);
        make.height.equalTo(@20);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)notificationConfig
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationChangPurchase:) name:@"puchaceChage" object:nil];
}

- (void)notificationChangPurchase:(NSNotification *)noti
{
    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    BOOL isweek = [noti.userInfo[@"isWeek"]intValue];
    self.isWeakPurchase = isweek;
}

#pragma mark - setter & getter
- (UIImageView *)bottomImageView
{
    if(!_bottomImageView){
        _bottomImageView = [[UIImageView alloc]init];
        _bottomImageView.backgroundColor = [UIColor xwColorWithHexString:@"#373737"];
    }
    return _bottomImageView;
}

- (UIImageView *)imageView3
{
    if(!_imageView3){
        _imageView3 = [[UIImageView alloc]init];
        _imageView3.image = XWImageName(@"组34");
        [_imageView3 xwDrawCornerWithRadiuce:8];
    }
    return _imageView3;
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
        _freeLabel.text = NSLocalizedString(@"TRY FOR FREE", nil);
        _freeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _freeLabel;
}

- (UIButton *)buyButtonBottom
{
    if(!_buyButtonBottom){
        _buyButtonBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_buyButtonBottom setBackgroundImage:XWImageName(@"组25") forState:UIControlStateNormal];
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
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
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

- (void)setIsWeakPurchase:(BOOL)isWeakPurchase
{
    _isWeakPurchase = isWeakPurchase;
    if(isWeakPurchase){
        self.freeLabel.text = NSLocalizedString(@"$0.99/Week", nil);
    }else{
        self.freeLabel.text = NSLocalizedString(@"TRY FOR FREE", nil);
    }
}


- (UIView *)textView
{
    if(!_textView){
        _textView = [[UIView alloc]init];
        [_textView addSubview:self.line1Label];
        [_textView addSubview:self.line2Label];
        [_textView addSubview:self.line4Label];
        [_textView addSubview:self.line1ImageView];
        [_textView addSubview:self.line2ImageView];
        [_textView addSubview:self.line4ImageView];
        
        [self.line1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textView);
            make.left.equalTo(self.line1ImageView.mas_right).offset(15);
            make.top.equalTo(_textView).offset(30);
        }];
        [self.line2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textView);
            make.left.equalTo(self.line2ImageView.mas_right).offset(15);
            make.top.equalTo(self.line1Label.mas_bottom).offset(27);
        }];
        [self.line4Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textView);
            make.left.equalTo(self.line4ImageView.mas_right).offset(15);
            make.top.equalTo(self.line2Label.mas_bottom).offset(27);
            make.bottom.equalTo(_textView).offset(-30);
        }];
        
        [self.line1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@22);
            make.top.equalTo(self.line1Label);
            make.left.equalTo(_textView);
        }];
        [self.line2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@22);
            make.top.equalTo(self.line2Label);
            make.left.equalTo(_textView);
        }];
        [self.line4ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@22);
            make.top.equalTo(self.line4Label);
            make.left.equalTo(_textView);
        }];
        
    }
    return _textView;
}

- (UILabel *)line1Label
{
    if(!_line1Label){
        _line1Label = [[UILabel alloc]init];
        [_line1Label commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:18] aliment:NSTextAlignmentLeft];
        _line1Label.numberOfLines = 2;
        _line1Label.text = NSLocalizedString(@"Cancel it at anytime",nil);
    }
    return _line1Label;
}

- (UILabel *)line2Label
{
    if(!_line2Label){
        _line2Label = [[UILabel alloc]init];
        [_line2Label commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:18] aliment:NSTextAlignmentLeft];
        _line2Label.numberOfLines = 2;
        _line2Label.text = NSLocalizedString(@"100% free during the trial period",nil);
    }
    return _line2Label;
}

- (UILabel *)line4Label
{
    if(!_line4Label){
        _line4Label = [[UILabel alloc]init];
        [_line4Label commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"Helvetica" size:18] aliment:NSTextAlignmentLeft];
        _line4Label.numberOfLines = 2;
        _line4Label.text = NSLocalizedString(@"You will never regret it",nil);
    }
    return _line4Label;
}

- (UIImageView *)line1ImageView{
    if(!_line1ImageView){
        _line1ImageView = [[UIImageView alloc]initWithImage:XWImageName(@"白色勾")];
        [_line1ImageView xwDrawCornerWithRadiuce:5];
    }
    return _line1ImageView;
}

- (UIImageView *)line2ImageView{
    if(!_line2ImageView){
        _line2ImageView = [[UIImageView alloc]initWithImage:XWImageName(@"白色勾")];
        [_line2ImageView xwDrawCornerWithRadiuce:5];
    }
    return _line2ImageView;
}

- (UIImageView *)line4ImageView{
    if(!_line4ImageView){
        _line4ImageView = [[UIImageView alloc]initWithImage:XWImageName(@"白色勾")];
        [_line4ImageView xwDrawCornerWithRadiuce:5];
    }
    return _line4ImageView;
}

@end
