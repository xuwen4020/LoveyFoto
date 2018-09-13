//
//  XWBaseAlertView.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWBaseAlertView.h"
#import "XWKitDefines.h"
#import "UIView+XWUtils.h"

@interface XWBaseAlertView()
@property (nonatomic, strong, readwrite) UIView *placeView;
@property (nonatomic, assign) XWBaseAlertViewStyle style;
@end

@implementation XWBaseAlertView
#pragma mark - init
- (instancetype)initWithStyle:(XWBaseAlertViewStyle)style {
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    if (self) {
        self.style = style;
        [self baseUIConfig];
    }
    return self;
}

#pragma mark - baseUIConfig
- (void)baseUIConfig {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    [self addSubview:self.placeView];
}

#pragma mark - public
- (void)appearAnimation {
    self.alpha = 0.1f;
    __weak typeof(self) weak_self = self;
    switch (self.style) {
        case XWBaseAlertViewStyleCenter: {
            self.placeView.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
            [UIView animateWithDuration:0.3f animations:^{
                weak_self.alpha = 1.0f;
                weak_self.placeView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05f animations:^{
                    weak_self.placeView.transform = CGAffineTransformMakeScale(1.03f, 1.03f);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.05f animations:^{
                        weak_self.placeView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                    }];
                }];
            }];
            break;
        }
        case XWBaseAlertViewStyleBottom: {
            self.placeView.frame = CGRectMake(self.placeView.origin.x, kSCREEN_HEIGHT, self.placeView.width, self.placeView.height);
            [UIView animateWithDuration:0.5f animations:^{
                weak_self.placeView.frame = CGRectMake(self.placeView.origin.x, kSCREEN_HEIGHT - self.placeView.height, self.placeView.width, self.placeView.height);
                weak_self.alpha = 1.0f;
            }];
            break;
        }
        default:
            break;
    }
}

- (void)disappearAnimation {
    __weak typeof(self) weak_self = self;
    [self endEditing:YES];
    switch (self.style) {
        case XWBaseAlertViewStyleCenter: {
            [UIView animateWithDuration:0.3f animations:^{
                weak_self.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                weak_self.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [weak_self.placeView removeFromSuperview];
                [weak_self removeFromSuperview];
            }];
            break;
        }
        case XWBaseAlertViewStyleBottom: {
            [UIView animateWithDuration:0.3f animations:^{
                weak_self.placeView.frame = CGRectMake(self.placeView.origin.x, kSCREEN_HEIGHT, self.placeView.width, self.placeView.height);
                weak_self.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [weak_self.placeView removeFromSuperview];
                [weak_self removeFromSuperview];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - setter & getter
- (UIView *)placeView {
    if (!_placeView) {
        _placeView = [[UIView alloc] init];
        _placeView.backgroundColor = [UIColor whiteColor];
    }
    return _placeView;
}
@end
