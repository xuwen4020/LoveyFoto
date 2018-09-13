//
//  XWAgeRangePickerView.h
//  Project
//
//  Created by xuwen on 2018/7/17.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBaseAlertView.h"
typedef void(^HasRangePicker)(NSInteger minAge,NSInteger maxAge);
@interface XWAgeRangePickerView : XWBaseAlertView

@property (nonatomic,copy) HasRangePicker rspBlock;
- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style;
//- (void)reloadData;
@end
