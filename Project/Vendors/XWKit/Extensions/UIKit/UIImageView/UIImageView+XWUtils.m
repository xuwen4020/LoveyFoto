//
//  UIImageView+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIImageView+XWUtils.h"

@implementation UIImageView (XWUtils)
- (void)addTapTarget:(nullable id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [tag setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tag];
}
@end
