//
//  SADefaultView.m
//  Project
//
//  Created by xuwen on 2018/6/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "SADefaultView.h"

@interface SADefaultView()
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,strong) UIImageView *defaultImage;
@property (nonatomic,strong) UILabel *defaultLabel;
@end

@implementation SADefaultView

- (instancetype)initWithFrame:(CGRect)frame andSerch:(BOOL)isSerch
{
    self = [super initWithFrame: frame];
    if(self){
        self.isSearch = isSerch;
        self.backgroundColor = [UIColor projectBackGroudColor];
        [self addSubview:self.defaultImage];
        [self addSubview:self.defaultLabel];
        [self.defaultImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@170);
            make.height.equalTo(@150);
            make.center.equalTo(self);
        }];
        [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.defaultImage.mas_bottom).offset(20);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - setter & getter
- (UIImageView *)defaultImage
{
    if(!_defaultImage){
        if(self.isSearch){
            _defaultImage = [[UIImageView alloc]initWithImage:XWImageName(@"搜索空")];
        }else{
            _defaultImage = [[UIImageView alloc]initWithImage:XWImageName(@"Nocollection")];
        }
    }
    return _defaultImage;
}

- (UILabel *)defaultLabel
{
    if(!_defaultLabel){
        _defaultLabel = [[UILabel alloc]init];
        [_defaultLabel commonLabelConfigWithTextColor:[UIColor xwColorWithHexString:@"#CDCDCD"] font:Font(20) aliment:NSTextAlignmentCenter];
        if(self.isSearch){
            _defaultLabel.text = @"Your Past Order is Not Found";
        }else{
//            _defaultLabel.text = @"No Datas";
        }
    }
    return _defaultLabel;
}

@end
