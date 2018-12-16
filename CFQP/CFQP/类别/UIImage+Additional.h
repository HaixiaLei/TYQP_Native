//
//  UIImage+Additional.h
//  ShowMessage
//
//  Created by Heguiting on 8/17/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additional)

/*
 * 把img转为需要的宽高、并且旋转为向上位置
 */
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate;

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

/**
 * 用制订的contentMode进行drawInRect(drawRect方法中)
 */
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

/**
 * 用矩形进行drawInRect
 */
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;

/**
 * 用UIColor创建image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*圆角*/
- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius;

@end
