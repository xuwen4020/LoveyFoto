//
//  BZPurchaseHelper.m
//  Project
//
//  Created by xuwen on 2018/9/12.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "BZPurchaseHelper.h"

@interface BZPurchaseHelper()

@property (nonatomic,strong) NSString *yearPriceStr;
@property (nonatomic,strong) NSString *weekPriceStr;
@property (nonatomic,strong) NSString *freeTrialStr;
@property (nonatomic,strong) NSString *tryForFreeStr;

/* 外部显示 */
@property (nonatomic,strong) NSString *weekStr;
@property (nonatomic,strong) NSString *yearTopStr;
@property (nonatomic,strong) NSString *yearBottomStr;
@property (nonatomic,strong) NSString *purchaseDescpription;

@end

@implementation BZPurchaseHelper
SingletonM(BZPurchaseHelper)

- (void)getValues
{
    [self configInit];
    [self configDisplay];
}

- (void)configInit
{
    self.weekStr = [NSString string];
    self.yearTopStr = [NSString string];
    self.yearBottomStr = [NSString string];
    self.purchaseDescpription = [NSString string];
    
    self.weekPriceStr = NSLocalizedString(@"$0.99/Week", nil);
    self.yearPriceStr = NSLocalizedString(@"$49.99/Year", nil);
    self.freeTrialStr = NSLocalizedString(@"3 DATS FREE TRIAL", nil);
    self.tryForFreeStr = NSLocalizedString(@"TRY FOR FREE", nil);
    self.purchaseDescpription = NSLocalizedString(@"Unless the subscription is cancelled within 24 hours, or it will be auto- renewed for $0.99 a week and $49.99 a year.The subscription fee is charged to your iTunes account at confirmation of purchase.You may manage your subscription and turn off auto-renewal by going to your Setting after purchase. No cancellation of the current  subscription is allowed during active period.", nil);
    
    //替换价格
    self.weekPriceStr = [self.weekPriceStr stringByReplacingOccurrencesOfString:@"0.99"withString:[NSString stringWithFormat:@"%.2f",kUser.weekPrice]];
    self.yearPriceStr = [self.yearPriceStr stringByReplacingOccurrencesOfString:@"49.99" withString:[NSString stringWithFormat:@"%.2f",kUser.yearPrice]];
    self.purchaseDescpription = [self.purchaseDescpription stringByReplacingOccurrencesOfString:@"0.99"withString:[NSString stringWithFormat:@"%.2f",kUser.weekPrice]];
    self.purchaseDescpription = [self.purchaseDescpription stringByReplacingOccurrencesOfString:@"49.99"withString:[NSString stringWithFormat:@"%.2f",kUser.yearPrice]];
    
}

- (void)configDisplay
{
    switch ([self indexOfType]) {
        case 1:
        {
            self.weekStr = self.weekPriceStr;
            self.yearTopStr = self.yearPriceStr;
            self.yearBottomStr =  nil;
        }
            break;
        case 2:
        {
            self.weekStr = self.weekPriceStr;
            self.yearTopStr = self.freeTrialStr;
            self.yearBottomStr =  self.yearPriceStr;
        }
            break;
        case 3:
        {
            self.weekStr = self.weekPriceStr;
            self.yearTopStr = self.tryForFreeStr;
            self.yearBottomStr =  nil;
        }
            break;
        case 4:
        {
            self.weekStr = self.weekPriceStr;
            self.yearTopStr = self.tryForFreeStr;
            self.yearBottomStr =  self.yearPriceStr;
        }
            break;
        default:
            break;
    }
}

- (NSInteger)indexOfType
{
    if(kUser.isApple){
        if(kUser.reviewing){
            return 1;
        }else{
            return 2;
        }
    }else{
        if(kUser.reviewing){
            return 1;
        }else if(!kUser.yearPurchaseShowDetail){
            return 3;
        }else{
            return 4;
        }
    }
}

#pragma mark - Public

- (NSString *)weekString
{
    [self getValues];
    return self.weekStr;
}
- (NSString *)yearTopString
{
    [self getValues];
    return self.yearTopStr;
}
- (NSString *)yearBottomString
{
    [self getValues];
    return self.yearBottomStr;
}
- (NSString *)purchaseDescpriptionSting
{
    [self getValues];
    return self.purchaseDescpription;
}

#pragma mark - black config
- (NSString *)blackWeekString
{
    NSString *str = NSLocalizedString(@"$0.99/Week", nil);
    str=[str stringByReplacingOccurrencesOfString:@"0.99"withString:[NSString stringWithFormat:@"%.2f",kUser.weekPrice]];
    return str;
}

- (NSString *)blackYearString
{
    NSString *str = NSLocalizedString(@"$49.99/Year after 3", nil);
    str=[str stringByReplacingOccurrencesOfString:@"49.99"withString:[NSString stringWithFormat:@"%.2f",kUser.yearPrice]];
    return str;
}

@end
