//
//  XWCountDownLabel.m
//  Project
//
//  Created by XuWen on 2018/5/1.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWCountDownLabel.h"

@interface XWCountDownLabel()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation XWCountDownLabel

#pragma mark - init
+ (instancetype)sharedInstance
{
    static XWCountDownLabel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[XWCountDownLabel alloc] init];
    });
    return model;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self UIConstraint];
        [self start];
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hiden
{
    self.hidden = YES;
}

#pragma mark - event
- (void)timerStart
{
   
}

- (void)handleTimer
{
    NSString *dateStr = [NSDate stringSecondTodayRemain];
    self.text = dateStr;
}

#pragma mark - start

- (void)UIConstraint
{
    self.backgroundColor = [UIColor xwColorWithHexString:@"#B6B6CB"];
    [self commonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(18) aliment:NSTextAlignmentCenter];
}

//计时显示
- (void)start
{
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    //将NSTimer实例加到main runloop的特定mode（模式）中。避免被复杂运算操作或者UI界面刷新所干扰
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

@end
