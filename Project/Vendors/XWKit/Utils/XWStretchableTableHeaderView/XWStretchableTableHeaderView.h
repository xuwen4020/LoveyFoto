//
//  XWStretchableTableHeaderView.h
//  Project
//
//  Created by xuwen on 2018/7/24.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWStretchableTableHeaderView : NSObject
@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) UIView* view;

/**
 * subview:内容部分
 * view   :拉伸的背景图片
 */
- (void)stretchHeaderForTableView:(UITableView*)tableView
                         withView:(UIView*)view
                         subViews:(UIView*)subview;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

- (void)resizeView;

@end

/*
 *使用时要实现以下两个代理方法
 *- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 *- (void)viewDidLayoutSubviews
 */

/*
 使用方法
 
 - (XWStretchableTableHeaderView *)stretchHeaderView
 {
 if(!_stretchHeaderView){
 UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSTRETCHHEIGHT)];
 bgImageView.contentMode = UIViewContentModeScaleAspectFill;
 //        bgImageView.clipsToBounds = YES;
 bgImageView.image = XWImageName(@"3");
 //背景之上的内容
 //        UIView *contentView = [[UIView alloc] initWithFrame:bgImageView.bounds];
 //        contentView.backgroundColor = [UIColor blueColor];
 
 _stretchHeaderView = [[XWStretchableTableHeaderView alloc]init];
 [_stretchHeaderView stretchHeaderForTableView:self.mainTableView withView:bgImageView subViews:nil];
 }
 return _stretchHeaderView;
 }
 
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 [self.stretchHeaderView scrollViewDidScroll:scrollView];
 }
 
 - (void)viewDidLayoutSubviews
 {
 [self.stretchHeaderView resizeView];
 }
 
 */
