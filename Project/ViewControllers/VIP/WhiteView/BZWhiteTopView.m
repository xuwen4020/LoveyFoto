//
//  BZWhiteTopView.m
//  Project
//
//  Created by xuwen on 2018/9/13.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZWhiteTopView.h"
#import "BZPurchaseHelper.h"
@interface BZWhiteTopView()
@property (nonatomic,strong) UIImageView *topImageView;

@property (nonatomic,strong) UILabel *accesslabel;
@property (nonatomic,strong) UILabel *subLabel;

@property (nonatomic,strong) UIImageView *yearImageView;
@property (nonatomic,strong) UIImageView *weekImageView;
@property (nonatomic,strong) UILabel *yearLabel;
@property (nonatomic,strong) UILabel *weakLabel;
@property (nonatomic,strong) UIButton *buttonYear;
@property (nonatomic,strong) UIButton *buttonWeek;

//数据
@property (nonatomic,assign) BOOL isWeakPurchase;
@end

@implementation BZWhiteTopView
- (instancetype)initWithFrame:(CGRect)frame isCancelView:(BOOL)cancelView
{
    self = [self initWithFrame:frame];
    if(self){
        if(cancelView){
            self.accesslabel.text = NSLocalizedString(@"Are you sure?",nil);
        }
    }
    return self;
}

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
- (void)priceConfig
{
    self.yearLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]blackYearString];
    self.weakLabel.text = [[BZPurchaseHelper sharedBZPurchaseHelper]blackWeekString];
}

-(void)dealloc{
    [kUser removeObserver:self forKeyPath:@"yearPrice" context:nil];
}

#pragma mark - event
- (void)buttonChooseClicked:(UIButton *)sender
{
    self.isWeakPurchase = sender.tag;
    if(self.isWeakPurchase ){
        self.weekImageView.image = XWImageName(@"选中");
        self.weekImageView.backgroundColor = [UIColor clearColor];
        self.yearImageView.image = nil;
        self.yearImageView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        NSDictionary *dict = @{@"isWeek":@1};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"puchaceChage" object:nil userInfo:dict];
    }else{
        self.weekImageView.image = nil;
        self.weekImageView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.yearImageView.image = XWImageName(@"选中");
        self.yearImageView.backgroundColor = [UIColor clearColor];
        NSDictionary *dict = @{@"isWeek":@0};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"puchaceChage" object:nil userInfo:dict];
    }
}

#pragma mark - baseConfig

- (void)baseUIConfig
{
    [self addSubview:self.topImageView];
    
    [self addSubview:self.accesslabel];
    [self addSubview:self.subLabel];
    
    [self addSubview:self.yearImageView];
    [self addSubview:self.weekImageView];
}

- (void)baseConstraintConfig
{
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.accesslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10+kStatusBarHeight-20);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(@150);
        make.width.equalTo(@250);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accesslabel);
        make.top.equalTo(self.accesslabel.mas_bottom).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.yearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-5);
        make.height.equalTo(@50);
        make.top.equalTo(self.subLabel.mas_bottom).offset(47);
        make.left.equalTo(self.subLabel);
    }];
    
    [self.weekImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.yearImageView);
        make.height.equalTo(@50);
        make.top.equalTo(self.subLabel.mas_bottom).offset(47);
        make.left.equalTo(self.yearImageView.mas_right).offset(15);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)topImageView
{
    if(!_topImageView){
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = XWImageName(@"图层646");
        _topImageView.userInteractionEnabled = YES;
    }
    return _topImageView;
}

- (UILabel *)accesslabel
{
    if(!_accesslabel){
        _accesslabel = [[UILabel alloc]init];
        [_accesslabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:47] aliment:NSTextAlignmentLeft];
        _accesslabel.numberOfLines = 0;
        _accesslabel.text = NSLocalizedString(@"Start Free Trial Now!",nil);
        _accesslabel.adjustsFontSizeToFitWidth = YES;
    }
    return _accesslabel;
}

- (UILabel *)subLabel
{
    if(!_subLabel){
        _subLabel = [[UILabel alloc]init];
        [_subLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] aliment:NSTextAlignmentCenter];
        _subLabel.text = NSLocalizedString(@"Update! View more wallpapers",nil);
    }
    return _subLabel;
}

- (UIImageView *)yearImageView
{
    if(!_yearImageView){
        _yearImageView = [[UIImageView alloc]init];
        _yearImageView.backgroundColor = [UIColor clearColor];
        _yearImageView.image = XWImageName(@"选中");
        _yearImageView.userInteractionEnabled = YES;
        [_yearImageView xwDrawCornerWithRadiuce:10];
        [_yearImageView addSubview:self.yearLabel];
        [_yearImageView addSubview:self.buttonYear];
        
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yearImageView).offset(5);
            make.right.equalTo(_yearImageView).offset(-15);
            make.top.bottom.equalTo(_yearImageView);
        }];
        [self.buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_yearImageView);
        }];
    }
    return _yearImageView;
}

- (UIImageView *)weekImageView
{
    if(!_weekImageView){
        _weekImageView = [[UIImageView alloc]init];
        _weekImageView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _weekImageView.userInteractionEnabled = YES;
        [_weekImageView xwDrawCornerWithRadiuce:10];
        _weekImageView.image = nil;
        
        [_weekImageView addSubview:self.weakLabel];
        [_weekImageView addSubview:self.buttonWeek];
        [self.weakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weekImageView).offset(5);
            make.right.equalTo(_weekImageView).offset(-15);
            make.top.bottom.equalTo(_weekImageView);
        }];
        [self.buttonWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_weekImageView);
        }];
        _weekImageView.hidden = !kUser.showblackweekPurchase;
    }
    return _weekImageView;
}

- (UILabel *)yearLabel
{
    if(!_yearLabel){
        _yearLabel = [[UILabel alloc]init];
        [_yearLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(13) aliment:NSTextAlignmentLeft];
        _yearLabel.numberOfLines = 2;
        _yearLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _yearLabel;
}

- (UILabel *)weakLabel
{
    if(!_weakLabel){
        _weakLabel = [[UILabel alloc]init];
        [_weakLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:Font(13) aliment:NSTextAlignmentLeft];
        _weakLabel.numberOfLines = 2;
        _weakLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _weakLabel;
}

- (UIButton *)buttonWeek
{
    if(!_buttonWeek){
        _buttonWeek = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonWeek.backgroundColor = [UIColor clearColor];
        _buttonWeek.tag = 1;
        [_buttonWeek addTarget:self action:@selector(buttonChooseClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonWeek;
}

- (UIButton *)buttonYear
{
    if(!_buttonYear){
        _buttonYear = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonYear.backgroundColor = [UIColor clearColor];
        _buttonYear.tag = 0;
        [_buttonYear addTarget:self action:@selector(buttonChooseClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonYear;
}

@end
