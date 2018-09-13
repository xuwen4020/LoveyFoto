//
//  BZCollectionRecCell.m
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZCollectionRecCell.h"

@interface BZCollectionRecCell()
@property (nonatomic,strong) UIView *vipView;
@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UIView *moreView;
@property (nonatomic,strong) UILabel *moreLabel;
@end

@implementation BZCollectionRecCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

- (void)baseUIConfig
{
    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.moreView];
}

- (void)baseConstraintsConfig
{
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        [_bgImageView xwDrawCornerWithRadiuce:8];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bgImageView;
}

- (UIView *)shadowView
{
    if(!_shadowView){
        _shadowView = [[UIView alloc]init];
        [_shadowView shadowColor:[UIColor lightGrayColor] opacity:0.6 offset:CGSizeMake(0, 3) radius:8];
    }
    return _shadowView;
}

- (UIView *)vipView
{
    if(!_vipView){
        _vipView = [[UIView alloc]init];
        _vipView.backgroundColor = [UIColor yellowColor];
    }
    return _vipView;
}

- (UIView *)moreView
{
    if(!_moreView){
        _moreView = [[UIView alloc]init];
        _moreView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_moreView xwDrawCornerWithRadiuce:8];
        [_moreView addSubview:self.moreLabel];
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_moreView);
        }];
    }
    return _moreView;
}

- (UILabel *)moreLabel
{
    if(!_moreLabel){
        _moreLabel = [[UILabel alloc]init];
        [_moreLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30] aliment:NSTextAlignmentCenter];
        [_moreLabel xwDrawCornerWithRadiuce:8];
        _moreLabel.text = NSLocalizedString(@"More",nil);
    }
    return _moreLabel;
}

- (void)setShowMoreToVIP:(BOOL)showMoreToVIP
{
    _showMoreToVIP = showMoreToVIP;
    self.moreView.hidden = !showMoreToVIP;
}

@end
