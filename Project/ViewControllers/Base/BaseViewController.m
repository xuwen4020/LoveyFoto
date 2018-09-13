//
//  BaseViewController.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingImageView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor projectBackGroudColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBZHUD
{
     [self.loadingImageView startAnimating];
    [self.view addSubview:self.bgView];
}

- (void)hideBZHUD
{
    [self.bgView removeFromSuperview];
    [self.loadingImageView stopAnimating];
}

#pragma mark - setter & getter

- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [_bgView addSubview:self.loadingView];
        [_loadingView addSubview:self.loadingImageView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.center.equalTo(_bgView);
        }];
        [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
            make.center.equalTo(self.loadingView);
        }];
    }
    return _bgView;
}

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
       
    }
    return _loadingImageView;
}

@end
