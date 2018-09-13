//
//  BZSubjectVC.h
//  Project
//
//  Created by xuwen on 2018/8/21.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BaseViewController.h"
#import "BZMainViewController.h"

@interface BZSubjectVC : BaseViewController
@property (nonatomic,weak) UIViewController *parentVC;
- (void)loadDataReload;
@end
