//
//  XWiCloudManager.m
//  Project
//
//  Created by xuwen on 2018/8/28.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "XWiCloudManager.h"

@implementation XWiCloudManager
+ (BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    return NO;
}

+ (NSURL *)iCloudFilePathByName:(NSString *)name {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url == nil) {
        return nil;
    }
    url = [url URLByAppendingPathComponent:@"Documents"];
    NSURL *iCloudPath = [NSURL URLWithString:name relativeToURL:url];
    return iCloudPath;
}



@end
