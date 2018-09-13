//
//  XWHTMLViewController.m
//  Project
//
//  Created by xuwen on 2018/7/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWHTMLViewController.h"

@interface XWHTMLViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation XWHTMLViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseUIConfig];
    [self baseConstraintsConfig];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.style == 0?@"Privacy":@"Terms" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - public

#pragma mark - private

#pragma mark - event

#pragma mark - baseConfig
- (void)baseUIConfig
{
    [self navBackButton];
    [self commonViewControllerConfigWithTitle:self.style == 0?@"Privacy policy":@"Terms and Conditions"];
    [self.view addSubview:self.webView];
}

- (void)baseConstraintsConfig
{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
    }];
}

#pragma mark - setter & getter
- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc]init];
    }
    return _webView;
}
@end
