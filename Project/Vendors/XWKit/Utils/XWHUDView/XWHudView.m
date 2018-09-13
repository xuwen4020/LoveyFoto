//
//  XWHudView.m
//  Project
//
//  Created by xuwen on 2018/9/3.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWHudView.h"

@interface XWHudView()
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingImageView;
@end

@implementation XWHudView

+ (XWHudView *)shareInstance{
    static XWHudView * singleton = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton == nil) {
            singleton = [[XWHudView alloc] initWithStyle:XWBaseAlertViewStyleCenter];
        }
    });
    return (XWHudView *)singleton;
}


+ (void)showHUD
{
    XWHudView *hud = [XWHudView shareInstance];
    [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    [hud appearAnimation];
}

+ (void)hideHUD
{
    XWHudView *hud = [XWHudView shareInstance];
    [hud disappearAnimation];
}

#pragma mark - init

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self baseConstraintsConfig];
    }
    return self;
}


#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    self.placeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.placeView];
    [self.placeView addSubview:self.loadingView];
    [self.loadingView addSubview:self.loadingImageView];
}

- (void)baseConstraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.center.equalTo(self.placeView);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.center.equalTo(self.loadingView);
    }];
}

#pragma mark - setter & getter
- (UIView *)loadingView
{
    if(!_loadingView){
        _loadingView = [[UIView alloc]init];
        _loadingView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [_loadingView xwDrawCornerWithRadiuce:15];
    }
    return _loadingView;
}

- (UIImageView *)loadingImageView
{
    if(!_loadingImageView){
        _loadingImageView = [[UIImageView alloc]init];
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0;i<136;i++){
            NSString *str =  [NSString stringWithFormat:@"19_white_00%03d",i];
            [array addObject:XWImageName(str)];
        }
        _loadingImageView.animationDuration = 2.0;
        _loadingImageView.animationImages = array;
        _loadingImageView.animationRepeatCount = 0;
        [_loadingImageView startAnimating];
    }
    return _loadingImageView;
}

@end
