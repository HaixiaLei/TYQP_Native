//
//  UIView+Additional.h
//  ShowMessage
//
//  Created by Heguiting on 8/18/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJDBezierCurve.h"

typedef NS_ENUM(NSUInteger, HgtAnimateShowMode){
    HgtAnimateShowModeFromLeft = 0,
    HgtAnimateShowModeFromRight ,
    HgtAnimateShowModeFromTop ,
    HgtAnimateShowModeFromBottom ,
    HgtAnimateShowModeFan ,
};

@interface UIView (Additional)

/**
 *  返回／设定 view的坐标
 */
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;
@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

/**
 * 遍历自己和自己的subviews，找到第一个属于某个class的view返回
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * 遍历自己和自己的superViews，找到第一个属于某个class的view返回
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * 删除所有subview
 */
- (void)removeAllSubviews;

/**
 * 返回相对于otherview的偏移量
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 * 返回自己的视图控制器
 */
- (UIViewController*)viewController;

/**
 * 返回第一响应者
 */
- (UIView *)firstResponder;

/**
 * 回收软键盘
 */
-(void)resignKeyBoard;

/**
 *  用贝塞尔曲线设置view走位
     Point2D start;
     Point2D end;
     Point2D control1;
     Point2D control2;
     start.x = 0.0;
     start.y = 0.0;
     end.x = 1.0;
     end.y = 1.0;
     control1.x = 0.75;
     control1.y = 0.0;
     control2.x = 1.0;
     control2.y = 1.0;
     Point2D p[4] = {start,control1,control2,end};
 */
-(void)setFrame:(CGRect)frame withBezier:(Point2D *)fBezier curveWithBezier:(Point2D *)cBezier isHorizon:(BOOL)horizon timeInterval:(NSTimeInterval)interval completion:(void(^)(void))completion;

/**
 *  慢慢出现
 */
-(void)showAfterDelay:(NSTimeInterval)delay mode:(HgtAnimateShowMode)mode duration:(NSTimeInterval)duration completion:(void(^)(void))completion;

/**
 *  把自己转化为image
 */
- (UIImage *)changeToImage;

/**
 *  将自己的部分转化为image
 */
- (UIImage *)changeToImageWithRect:(CGRect)rect;



/**  设置圆角  */
- (void)rounded:(CGFloat)cornerRadius;

/**  设置圆角和边框  */
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**  设置边框  */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**   给哪几个角设置圆角  */
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**  设置阴影  */
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

@end


























