//
//  XWAgeRangePickerView.m
//  Project
//
//  Created by xuwen on 2018/7/17.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWAgeRangePickerView.h"

@interface XWAgeRangePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIPickerView *mainPickerView;
@property (nonatomic, assign) NSInteger minAge;
@property (nonatomic, assign) NSInteger maxAge;

@property (nonatomic,strong) NSMutableArray *minAgeArray;
@property (nonatomic,strong) NSMutableArray *maxAgeArray;
@end

@implementation XWAgeRangePickerView

- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style
{
    self = [super initWithStyle:style];
    if(self){
        [self baseUIConfig];
        [self constraintsConfig];
        [self.mainPickerView selectRow:0 inComponent:0 animated:nil];
        [self.mainPickerView selectRow:0 inComponent:1 animated:nil];
        self.minAge = 18;
        self.maxAge = 18;
    }
    return self;
}

#pragma mark -
#pragma mark Event
- (void)cancelButtonClicked:(UIButton *)sender
{
    [self disappearAnimation];
}

- (void)confirmButtonClicked:(UIButton *)sender
{
    if(self.minAge > self.maxAge){
        [self showHint:@"error"];
        return;
    }
    
    if(self.rspBlock){
        self.rspBlock(self.minAge,self.maxAge);
    }
    self.rspBlock = nil;
    [self disappearAnimation];
}

#pragma mark -
#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.minAgeArray.count;
    }else{
        return self.maxAgeArray.count;
    }
//    return 20;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *minLabel = [UILabel new];
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.textColor = [UIColor whiteColor];
    minLabel.text = @"1";
    if(component == 0){
        minLabel.text = self.minAgeArray[row];
    }else{
        minLabel.text = self.maxAgeArray[row];
    }
    return minLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        if (row < self.minAgeArray.count){
            int min = [self.minAgeArray[row] intValue];
            self.minAge = min;
        }
    }else{
        if (row < self.maxAgeArray.count){
            int max = [self.maxAgeArray[row] intValue];
            self.maxAge = max;
        }
    }
    if(self.minAge > self.maxAge){
        return;
    }
}

#pragma mark -
#pragma mark Configer
- (void)baseUIConfig
{
    self.placeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    self.placeView.backgroundColor = [UIColor whiteColor];
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
    }
    return _mainPickerView;
}

- (NSMutableArray *)minAgeArray
{
    if(!_minAgeArray){
        _minAgeArray = [NSMutableArray array];
        for(int i = 18;i<=60;i++){
            [_minAgeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _minAgeArray;
}
- (NSMutableArray *)maxAgeArray
{
    if(!_maxAgeArray){
        _maxAgeArray = [NSMutableArray array];
        for(int i = 18;i<=60;i++){
            [_maxAgeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _maxAgeArray;
}

@end
