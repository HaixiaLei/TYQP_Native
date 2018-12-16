//
//  UIButton+Additional.h
//  AGAnnual
//
//  Created by iosdev on 2018/1/3.
//  Copyright © 2018年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>   

typedef void(^ButtonClickCallBack)(UIButton *button);

@interface UIButton (Additional)

- (void)handleCallBack:(ButtonClickCallBack)callBack forEvent:(UIControlEvents)event;

@end
