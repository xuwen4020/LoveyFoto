//
//  XWSinglePickerView.m
//  Project
//
//  Created by xuwen on 2018/7/16.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWSinglePickerView.h"

@interface XWSinglePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIPickerView *mainPickerView;
@property (nonatomic,strong) NSString *currentSelectedString;
@end

@implementation XWSinglePickerView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self constraintsConfig];
//        self.currentSelectedString = @"Male";
    }
    return self;
}

#pragma mark -
#pragma mark Public
- (void)reloadData
{
    if (self.dataArray.count > 0) {
        self.currentSelectedString = self.dataArray[0];
    }
    [self.mainPickerView reloadAllComponents];

    if (self.lastString) {
        for (NSString *str in self.dataArray) {
            if ([str isEqualToString:self.lastString]) {
                [self.mainPickerView selectRow:[self.dataArray indexOfObject:str] inComponent:0 animated:true];
                self.currentSelectedString = str;
                break;
            }
        }
    }
}

#pragma mark -
#pragma mark Event
- (void)cancelButtonClicked:(UIButton *)sender
{
    [self disappearAnimation];
}

- (void)confirmButtonClicked:(UIButton *)sender
{
    if(self.rspBlock){
        self.rspBlock(self.currentSelectedString);
    }
    self.rspBlock = nil;
    [self disappearAnimation];
}

#pragma mark -
#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = self.dataArray[row];
    genderLabel.textColor = [UIColor whiteColor];
    return genderLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < self.dataArray.count) {
        self.currentSelectedString = self.dataArray[row];
    }
}

#pragma mark -
#pragma mark Configer
- (void)baseUIConfig
{
    self.placeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self addSubview:self.placeView];
    
    [self.placeView addSubview:self.cancelButton];
    [self.placeView addSubview:self.confirmButton];
    [self.placeView addSubview:self.mainPickerView];
}

- (void)constraintsConfig
{
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(250+kSafeAreaBottomHeight));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeView);
        make.left.equalTo(self.placeView);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeView);
        make.right.equalTo(self.placeView);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    [self.mainPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton.mas_bottom);
        make.left.equalTo(self.placeView);
        make.right.equalTo(self.placeView);
        make.bottom.equalTo(self.placeView);
    }];
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton commonButtonConfigWithTitle:@"cancel" font:Font(17) titleColor:[UIColor projectSubTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_confirmButton commonButtonConfigWithTitle:@"确定" font:[UIFont system16] titleColor:[UIColor projectMainTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_confirmButton commonButtonConfigWithTitle:@"OK" font:Font(17) titleColor:[UIColor projectSubTextColor] aliment:UIControlContentHorizontalAlignmentCenter];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIPickerView *)mainPickerView
{
    if (!_mainPickerView) {
        _mainPickerView = [[UIPickerView alloc] init];
        _mainPickerView.delegate = self;
        _mainPickerView.dataSource = self;
        _mainPickerView.showsSelectionIndicator = true;
//        _mainPickerView.backgroundColor = [UIColor projectBackGroudColor];
    }
    return _mainPickerView;
}

@end
