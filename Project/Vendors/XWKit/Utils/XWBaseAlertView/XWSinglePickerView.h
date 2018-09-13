//
//  XWSinglePickerView.h
//  Project
//
//  Created by xuwen on 2018/7/16.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBaseAlertView.h"

typedef void(^HasSinglePick)(NSString *rsp);

@interface XWSinglePickerView : XWBaseAlertView

@property (nonatomic, strong) NSArray * dataArray;
/** 回调结果 */
@property (nonatomic, copy) HasSinglePick rspBlock;
@property (nonatomic, strong) NSString *lastString;

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style;
- (void)reloadData;


/**
 使用说明
 
 XWSinglePickerView *pickerView = [[XWSinglePickerView alloc]initWithStyle:XWBaseAlertViewStyleBottom];
 
 pickerView.dataArray = @[@"1",@"2",@"3",];
 pickerView.rspBlock = ^(NSString *rsp) {
 
 };
 [[[UIApplication sharedApplication] keyWindow] addSubview:pickerView];
 [pickerView appearAnimation];
 */
@end
