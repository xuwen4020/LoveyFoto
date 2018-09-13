//
//  CityAndCountryList.h
//  ddddd
//
//  Created by yanll on 16/10/17.
//  Copyright © 2016年 icsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedCityBlock)(NSString *city);
@interface CityAndCountryList : UIViewController
@property (nonatomic) SelectedCityBlock  selectedCityBlock;
@end


/**
 
 使用方式
 
 CityAndCountryList *vc = [[CityAndCountryList alloc] init];
 [self.navigationController presentViewController:vc animated:YES completion:nil];
 kXWWeakSelf(weakSelf);
 vc.selectedCityBlock = ^(NSString *city) {
 weakSelf.cityView.subtitle = city;
 //        [[XWUserManager sharedXWUserManager]saveCity:city];
 weakSelf.city = [NSString stringWithString:city];
 };
 
 */
