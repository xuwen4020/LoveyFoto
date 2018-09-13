//
//  XWHTMLViewController.h
//  Project
//
//  Created by xuwen on 2018/7/30.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, XWHTMLStyle) {
    XWHTMLPrivacy =0,
    XWHTMLTerms
};

@interface XWHTMLViewController : BaseViewController
@property (nonatomic,assign) XWHTMLStyle style;
@end
