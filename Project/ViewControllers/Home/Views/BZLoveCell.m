//
//  BZLoveCell.m
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZLoveCell.h"
#import "XWBrowserView.h"
#import "BZLiveVC.h"
#import "XWDoubleBrowerView.h"

@interface BZLoveCell()
@property (nonatomic,assign) BOOL isLocked;
@property (nonatomic,strong) UIView *shadowView1;
@property (nonatomic,strong) UIView *shadowView2;
@end

@implementation BZLoveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}

- (void)imageLeftClicked
{
    if(!self.isLocked){
        self.isLocked = YES;
        [XWDoubleBrowerView showFromImageView:self.imageViewLeft andImageView:self.imageViewRight withURLStrings:self.dataArray placeholderImage:nil atIndex:self.leftIndex/2 parentView:self.eventVC.parentVC.view category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
            self.isLocked = NO;
        }];
    }
}

- (void)imageRightClicked
{
    if(!self.isLocked){
        self.isLocked = YES;
        [XWDoubleBrowerView showFromImageView:self.imageViewLeft andImageView:self.imageViewRight withURLStrings:self.dataArray placeholderImage:nil atIndex:self.leftIndex/2 parentView:self.eventVC.parentVC.view category:@"" dismiss:^(UIImage * _Nullable image, NSInteger index) {
            self.isLocked = NO;
        }];
        
    }
}

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self commonTableViewCellConfig];
    
    [self.contentView addSubview:self.shadowView1];
    [self.contentView addSubview:self.shadowView2];
    
    [self.contentView addSubview:self.imageViewLeft];
    [self.contentView addSubview:self.imageViewRight];
}

- (void)baseConstraintsConfig
{
    [self.shadowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageViewLeft);
    }];
    [self.shadowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageViewRight);
    }];
    
    [self.imageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView.mas_centerX).offset(-7.5);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.imageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView.mas_centerX).offset(7.5);
        make.top.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)imageViewLeft
{
    if(!_imageViewLeft){
        _imageViewLeft = [[UIImageView alloc]init];
        _imageViewLeft.backgroundColor = [UIColor lightGrayColor];
        _imageViewLeft.image = XWImageName(@"壁纸10");
        [_imageViewLeft addTapTarget:self action:@selector(imageLeftClicked)];
        [_imageViewLeft xwDrawCornerWithRadiuce:8];
    }
    return _imageViewLeft;
}

- (UIImageView *)imageViewRight
{
    if(!_imageViewRight){
        _imageViewRight = [[UIImageView alloc]init];
        _imageViewRight.backgroundColor = [UIColor lightGrayColor];
        _imageViewRight.image = XWImageName(@"壁纸10");
        [_imageViewRight addTapTarget:self action:@selector(imageRightClicked)];
        [_imageViewRight xwDrawCornerWithRadiuce:8];
    }
    return _imageViewRight;
}

- (UIView *)shadowView1
{
    if(!_shadowView1){
        _shadowView1 = [[UIView alloc]init];
        [_shadowView1 shadowColor:[UIColor lightGrayColor] opacity:0.4 offset:CGSizeMake(2, 2) radius:8];
    }
    return _shadowView1;
}
- (UIView *)shadowView2
{
    if(!_shadowView2){
        _shadowView2 = [[UIView alloc]init];
        [_shadowView2 shadowColor:[UIColor lightGrayColor] opacity:0.4 offset:CGSizeMake(2, 2) radius:8];
    }
    return _shadowView2;
}

@end
