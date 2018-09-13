//
//  BZMoreVC.h
//  Project
//
//  Created by xuwen on 2018/8/22.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BaseViewController.h"
#import "LCPPlayerDataModel.h"

@interface BZMoreVC : BaseViewController
@property (nonatomic, strong) NSArray <LCPPlayerDataModel *>*dataArray;
@property (nonatomic,assign) BOOL isCollection;
@end
