//
//  UIView+SADefaultView.m
//  Project
//
//  Created by xuwen on 2018/6/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIView+SADefaultView.h"
#import "SADefaultView.h"

@implementation UIView (SADefaultView)

- (void)showSearchInView:(UIView *)view isShow:(BOOL)isShow
{
    if(isShow){
        [self showSearchDefaultInView:view];
    }else{
        [self hideDefaultView];
    }
}

- (void)showDefaultInView:(UIView *)view isShow:(BOOL)isShow
{
    if(isShow){
        [self showDefaultViewInView:view];
    }else{
        [self hideDefaultView];
    }
}

- (void)showDefaultViewInView:(UIView *)view
{
    BOOL flag = 0;
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[SADefaultView class]]){
            flag = 1;
        }
    }
    if(flag == 0){
        SADefaultView *deView = [[SADefaultView alloc]initWithFrame:CGRectZero andSerch:NO];
        [self addSubview:deView];
        [deView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self bringSubviewToFront:deView];
    }
}

- (void)showSearchDefaultInView:(UIView *)view
{
    BOOL flag = 0;
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[SADefaultView class]]){
            flag = 1;
        }
    }
    if(flag == 0){
        SADefaultView *deView = [[SADefaultView alloc]initWithFrame:CGRectZero andSerch:YES];
        [self addSubview:deView];
        [deView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self bringSubviewToFront:deView];
    }
}

- (void)hideDefaultView
{
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[SADefaultView class]]){
            [view removeFromSuperview];
        }
    }
}
@end
