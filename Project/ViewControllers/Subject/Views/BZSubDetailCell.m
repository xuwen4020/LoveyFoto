//
//  BZSubDetailCell.m
//  Project
//
//  Created by xuwen on 2018/8/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSubDetailCell.h"

@interface BZSubDetailCell()
@property (nonatomic,strong) UIView *shadowView;
@end

@implementation BZSubDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self commonTableViewCellConfig];
    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.bgImageView];
}

- (void)baseConstraintsConfig
{
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-35);
        make.left.equalTo(self.contentView).offset(35);
        make.right.equalTo(self.contentView).offset(-35);
    }];
}

- (UIView *)shadowView
{
    if(!_shadowView){
        _shadowView = [[UIView alloc]init];
        [_shadowView shadowColor:[UIColor lightGrayColor] opacity:0.4 offset:CGSizeMake(10, 10) radius:8];
    }
    return _shadowView;
}
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
        [_bgImageView xwDrawCornerWithRadiuce:8];
        _bgImageView.image = XWImageName(@"壁纸10");
    }
    return _bgImageView;
}
@end
