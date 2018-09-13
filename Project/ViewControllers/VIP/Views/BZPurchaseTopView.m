//
//  BZPurchaseTopView.m
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZPurchaseTopView.h"

@interface BZPurchaseTopView()
@property (nonatomic,strong) UILabel *accesslabel;
@property (nonatomic,strong) UIImageView *xinImageView1;
@property (nonatomic,strong) UIImageView *xinImageView2;
@property (nonatomic,strong) UIImageView *xinImageView3;

@property (nonatomic,strong) UIImageView *phoneImageView;

@end

@implementation BZPurchaseTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
        [self baseConstraintConfig];
    }
    return self;
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    [self addSubview:self.accesslabel];
    [self addSubview:self.phoneImageView];
    [self addSubview:self.xinImageView1];
    [self addSubview:self.xinImageView2];
    [self addSubview:self.xinImageView3];
}

- (void)baseConstraintConfig
{
    [self.accesslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10+kStatusBarHeight-20);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(@150);
        make.width.equalTo(@250);
    }];
    [self.xinImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.accesslabel.mas_right).offset(-20);
        make.top.equalTo(self.accesslabel);
    }];
    [self.xinImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.xinImageView1.mas_bottom).offset(10);
    }];
    [self.xinImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@27);
        make.right.equalTo(self.xinImageView2.mas_left).offset(-10);
        make.top.equalTo(self.xinImageView2.mas_bottom).offset(10);
    }];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@322.5);
        make.height.equalTo(@245);
        make.top.equalTo(self.accesslabel.mas_bottom).offset(20);
    }];
}

#pragma mark - setter & getter

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

- (UIImageView *)xinImageView1
{
    if(!_xinImageView1){
        _xinImageView1 = [[UIImageView alloc]init];
        _xinImageView1.image = XWImageName(@"实心桃心-13拷贝");
    }
    return _xinImageView1;
}
- (UIImageView *)xinImageView2
{
    if(!_xinImageView2){
        _xinImageView2 = [[UIImageView alloc]init];
        _xinImageView2.image = XWImageName(@"实心桃心-13拷贝");
    }
    return _xinImageView2;
}
- (UIImageView *)xinImageView3
{
    if(!_xinImageView3){
        _xinImageView3 = [[UIImageView alloc]init];
        _xinImageView3.image = XWImageName(@"实心桃心-13拷贝");
    }
    return _xinImageView3;
}

- (UIImageView *)phoneImageView
{
    if(!_phoneImageView){
        _phoneImageView = [[UIImageView alloc]init];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0;i<50;i++){
            NSString *str =  [NSString stringWithFormat:@"111_000%02d",i];
            [array addObject:XWImageName(str)];
        }
        _phoneImageView.animationDuration = 5.0;
        _phoneImageView.animationImages = array;
        _phoneImageView.animationRepeatCount = 0;
        [_phoneImageView startAnimating];
    }
    return _phoneImageView;
}
@end
