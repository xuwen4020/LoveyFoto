//
//  BZCacelTopView.m
//  Project
//
//  Created by xuwen on 2018/9/13.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCacelTopView.h"

@interface BZCacelTopView()
@property (nonatomic,strong) UILabel *accesslabel;
@property (nonatomic,strong) UIImageView *xinImageView1;
@property (nonatomic,strong) UIImageView *xinImageView2;
@property (nonatomic,strong) UIImageView *xinImageView3;

@property (nonatomic,strong) UIView *textView;
@property (nonatomic,strong) UILabel *line1Label;
@property (nonatomic,strong) UILabel *line2Label;
@property (nonatomic,strong) UILabel *line4Label;
@property (nonatomic,strong) UIImageView *line1ImageView;
@property (nonatomic,strong) UIImageView *line2ImageView;
@property (nonatomic,strong) UIImageView *line4ImageView;

@end

@implementation BZCacelTopView

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
    
    [self addSubview:self.textView];
    
    
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
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@322.5);
//        make.height.equalTo(@200);
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
