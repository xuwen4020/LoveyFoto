//
//  UIBezierPath+XWUtils.m
//  Project
//
//  Created by xuwen on 2018/4/23.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#import "UIBezierPath+XWUtils.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

@implementation UIBezierPath (XWUtils)

//- (NSArray *)points {
//    NSMutableArray *points = [NSMutableArray array];
//    CGPathApply(self.CGPath, (__bridge void *)points, getPointsFromBezier);
//    return points;
//}
//
//void getPointsFromBezier(void *info,const CGPathElement *element) {
//    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
//    CGPathElementType type = element->type;
//    CGPoint *points = element->points;
//    if (type != kCGPathElementCloseSubpath) {
//        [bezierPoints addObject:VALUE(0)];
//        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
//            [bezierPoints addObject:VALUE(1)];
//        }
//    }
//    if (type == kCGPathElementAddCurveToPoint) {
//        [bezierPoints addObject:VALUE(2)];
//    }
//}

@end
