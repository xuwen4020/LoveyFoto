//
//  UIViewController+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIViewController+XWUtils.h"

@implementation UIViewController (XWUtils)
- (void)commonViewControllerConfigWithTitle:(NSString *)title {
    
    [self.navigationItem setTitle:title];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, kSCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor projectBorderColor];
    [self.navigationController.navigationBar addSubview:view];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontBold(18),NSForegroundColorAttributeName:[UIColor projectMainTextColor]}];
}

- (void)navBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}

- (void)backBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navBackBlankButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}

- (void)navBackToRootButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToRootBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}
- (void)backToRootBtnClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
