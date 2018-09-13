//
//  BZWelcomeViewController.m
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZWelcomeViewController.h"

@interface BZWelcomeViewController ()
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation BZWelcomeViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    [self.view addSubview:self.bgImageView];
}

- (void)baseConstraintsConfig
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [[UIImageView alloc]initWithImage:XWImageName(@"launch")];
    }
    return _bgImageView;
}
@end
