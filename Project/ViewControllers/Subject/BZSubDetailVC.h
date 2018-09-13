//
//  BZSubDetailVC.h
//  Project
//
//  Created by xuwen on 2018/8/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BaseViewController.h"
#import "BZSubjectVC.h"

@interface BZSubDetailVC : BaseViewController
@property (nonatomic,weak)  BZSubjectVC * parentVC;
@property (nonatomic,strong) NSArray <LCPPlayerDataModel *>*dataArray;
@end
