//
//  XWMessageAlertView.m
//  Project
//
//  Created by xuwen on 2018/8/27.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWMessageAlertView.h"
@interface XWMessageAlertView()
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,copy) XWMessageAlertViewDismissBlock block;
@end

@implementation XWMessageAlertView
+ (void)showSuccess:(NSString *)message block:(XWMessageAlertViewDismissBlock)block
{
    XWMessageAlertView *alert = [[XWMessageAlertView alloc]initWithFrame:CGRectZero];
    alert.block = block;
    [[[UIApplication sharedApplication] keyWindow] addSubview:alert];
    alert.messageLabel.text = message;
    [alert appearAnimation];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self baseUIConfig];
    }
    return self;
}

- (void)baseUIConfig
{
    self.backgroundColor = [[UIColor xwColorWithHexString:@"#3D9DF7"] colorWithAlphaComponent:0.8f];
    self.frame = CGRectMake(0, -100-kStatusBarHeight, kSCREEN_WIDTH, 100+kStatusBarHeight);
    [self addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@40);
    }];
}

- (void)appearAnimation
{
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
        self.frame = CGRectMake(0, -100+40, kSCREEN_WIDTH, 100+kStatusBarHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:2 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
            self.frame = CGRectMake(0, -100-kStatusBarHeight, kSCREEN_WIDTH, 100+kStatusBarHeight);
        } completion:^(BOOL finished) {
            if(self.block){
                self.block();
            }
            [self removeFromSuperview];
        }];
    }];
    
//    [UIView animateWithDuration:0.8 animations:^{
//        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40+kStatusBarHeight);
//    } completion:^(BOOL finished) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.8 animations:^{
//                self.frame = CGRectMake(0, -40+kStatusBarHeight, kSCREEN_WIDTH, 40+kStatusBarHeight);
//            } completion:^(BOOL finished) {
//                self.block();
//                [self removeFromSuperview];
//            }];
//        });
//    }];
}


- (UILabel *)messageLabel
{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc]init];
        [_messageLabel commonLabelConfigWithTextColor:[UIColor whiteColor] font:FontBold(20) aliment:NSTextAlignmentCenter];
    }
    return _messageLabel;
}

@end
