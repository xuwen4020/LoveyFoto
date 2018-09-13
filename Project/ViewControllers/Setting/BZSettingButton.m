//
//  BZSettingButton.m
//  Project
//
//  Created by xuwen on 2018/9/11.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZSettingButton.h"

#define LANGUAGE_RIGHT_TO_LEFT \
^(){\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
NSArray *languages = [defaults objectForKey:@"AppleLanguages"];\
NSString *currentLanguage = [languages objectAtIndex:0];\
if ([currentLanguage rangeOfString:@"ar"].length>0) {\
return YES;\
}else{\
return NO;\
}\
}()

@interface BZSettingButton()
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *label;

@end

@implementation BZSettingButton

// test  target   selectort

- (instancetype _Nullable )initWithText:(NSString *_Nullable)text Target:(nullable id)target action:(SEL _Nullable)action
{
    self = [super init];
    if(self){
        [self addSubview:self.label];
        [self addSubview:self.button];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.label.text = text;
    }
    return self;
}

- (UIButton *)button
{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
    }
    return _button;
}

- (UILabel *)label
{
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        [_label commonLabelConfigWithTextColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:24] aliment:NSTextAlignmentLeft];
        _label.adjustsFontSizeToFitWidth = YES;
        if(LANGUAGE_RIGHT_TO_LEFT){
            _label.textAlignment = NSTextAlignmentRight;
        }
    }
    return _label;
}


@end
