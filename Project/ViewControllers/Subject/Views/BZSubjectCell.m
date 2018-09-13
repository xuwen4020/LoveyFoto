//
//  BZSubjectCell.m
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSubjectCell.h"

@interface BZSubjectCell()
@end

@implementation BZSubjectCell

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
    [self.contentView addSubview:self.bgImageView];
    
}

- (void)baseConstraintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(7.5);
        make.bottom.equalTo(self.contentView).offset(-7.5);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]init];
//        [_bgImageView xwDrawCornerWithRadiuce:8];
        _bgImageView.image = XWImageName(@"组18");
        [_bgImageView xwDrawCornerWithRadiuce:10];
        _bgImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bgImageView;
}
@end
