//
//  SANetworkManager.m
//  Project
//
//  Created by xuwen on 2018/6/29.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "SANetworkManager.h"
#import "Reachability.h"

@implementation SANetworkManager
+(BOOL )internetStatus {
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus) {
        case ReachableViaWiFi:
            return YES;
        case ReachableViaWWAN:
            return YES;
        case NotReachable:
            return NO;
        default:
            return NO;
    }
    
}
@end
