//
//  BZWhiteBottomView.h
//  Project
//
//  Created by xuwen on 2018/9/13.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZWhiteBottomView : UIView
@property (nonatomic,weak) BaseViewController *eventVC;

- (instancetype)initWithFrame:(CGRect)frame isCancelView:(BOOL)cancelView;

@end
