//
//  UIColor+CustomColors.m
//  Project
//
//  Created by xuwen on 2018/4/25.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)
+ (UIColor *)themeColor {
    return [UIColor xwColorWithHexString:@"#00b008"];
}
+ (UIColor *)projectBackGroudColor {
    return [UIColor xwColorWithHexString:@"#f3f3f7"];
}
+ (UIColor *)projectMainTextColor {
    return [UIColor xwColorWithHexString:@"#191A2A"];
}
+ (UIColor *)projectSubTextColor {
    return [UIColor xwColorWithHexString:@"#7E7E8D"];
}
+ (UIColor *)projectButtonBGColor {
    return [UIColor xwColorWithHexString:@"#737DFF"];
}
+ (UIColor *)projectRedColor{
    return [UIColor xwColorWithHexString:@"#FF6464"];
}
+ (UIColor *)projectBorderColor
{
    return [UIColor xwColorWithHexString:@"#eeeeee"];
}
@end
