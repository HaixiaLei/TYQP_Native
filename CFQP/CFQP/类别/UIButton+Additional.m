//
//  UIButton+Additional.m
//  AGAnnual
//
//  Created by iosdev on 2018/1/3.
//  Copyright © 2018年 iosdev. All rights reserved.
//

#import "UIButton+Additional.h"

static char *buttonClickKey;
@implementation UIButton (Additional)

- (void)handleCallBack:(ButtonClickCallBack)callBack forEvent:(UIControlEvents)event {
    objc_setAssociatedObject(self, &buttonClickKey, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(buttonClicked) forControlEvents:event];
}

- (void)buttonClicked {
    ButtonClickCallBack callBack = objc_getAssociatedObject(self, &buttonClickKey);
    if (callBack) {
        callBack(self);
    }
}

@end
