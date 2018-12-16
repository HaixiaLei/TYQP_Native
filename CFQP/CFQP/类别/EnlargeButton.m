//
//  EnlargeButton.m
//  DemonProject
//
//  Created by david on 2018/7/17.
//  Copyright © 2018年 david. All rights reserved.
//

#import "EnlargeButton.h"

@implementation EnlargeButton

//@property(nonatomic, strong) NSString *gid;
//@property(nonatomic, strong) NSString *order_method;
//@property(nonatomic, strong) NSString *type;
//@property(nonatomic, strong) NSString *wtype;
//@property(nonatomic, strong) NSString *rtype;
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    EnlargeButton *button = nil;
    if (button = [super buttonWithType:buttonType]) {
        button.gid = @"";
        button.order_method = @"";
        button.type = @"";
        button.wtype = @"";
        button.rtype = @"";
    }
    return button;
}

/**
 *  点击区域放大
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    
    if (fabs(_expandTop) > 0.5) {
        bounds = CGRectMake(bounds.origin.x, bounds.origin.y-_expandTop, bounds.size.width, bounds.size.height+_expandTop);
    }
    
    if (fabs(_expandLeft) > 0.5) {
        bounds = CGRectMake(bounds.origin.x-_expandLeft, bounds.origin.y, _expandLeft+bounds.size.width, bounds.size.height);
    }
    
    if (fabs(_expandRight) > 0.5) {
        bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width+_expandRight, bounds.size.height);
    }
    
    if (fabs(_expandSpecs) > 0.5) {
        bounds = CGRectInset(bounds, -_expandSpecs, -_expandSpecs);
    }
//    NSLog(@"按钮放大区域:%@,,Frame:%@",NSStringFromCGRect(bounds),NSStringFromCGRect(self.frame));
    return CGRectContainsPoint(bounds, point);
}

@end
