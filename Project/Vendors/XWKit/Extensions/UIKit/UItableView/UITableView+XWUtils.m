//
//  UITableView+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UITableView+XWUtils.h"

@implementation UITableView (XWUtils)
- (void)commonTableViewConfig {
    [self commonScrollViewConfig];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
}
@end


@implementation UIScrollView (XWUtils)
- (void)commonScrollViewConfig {
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = NO;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
@end

@implementation UITableViewCell (Custom)
- (void)commonTableViewCellConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}
@end
