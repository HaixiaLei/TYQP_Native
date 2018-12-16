//
//  UIView+Additional.m
//  ShowMessage
//
//  Created by Heguiting on 8/18/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import "UIView+Additional.h"
#import "NSTimer+Additional.h"
#import "NSTimer+Additional.h"

@implementation UIView (Additional)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIView *)firstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView firstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

-(void)resignKeyBoard{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        [window endEditing:YES];
    }
}

- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *aView in view.subviews) {
        if ([aView.subviews count] > 0) {
            [self resignKeyBoardInView:aView];
        }
        if ([aView isKindOfClass:[UITextView class]] || [aView isKindOfClass:[UITextField class]] ) {
            [aView resignFirstResponder];
        }
    }
}

//贝塞尔曲线 http://cubic-bezier.com/#.35,-0.22,.29,1.2
-(void)setFrame:(CGRect)frame withBezier:(Point2D *)fBezier curveWithBezier:(Point2D *)cBezier isHorizon:(BOOL)horizon timeInterval:(NSTimeInterval)interval completion:(void(^)(void))completion{
    static BOOL isRunning;
    if (isRunning) return;
    isRunning = YES;
    if (!fBezier) return;
    const NSInteger frames = 120;
    float dt = 1.0 / (frames - 1);
    for (int i = 0; i < frames; i++) {
        Point2D point = PointOnCubicBezier(fBezier, i*dt);
        float durationTime = point.x * interval;
        CGRect newFrame;
        newFrame.origin.x = point.y*(frame.origin.x-self.left) + self.left;
        newFrame.origin.y = point.y*(frame.origin.y-self.top) + self.top;
        newFrame.size.width = point.y*(frame.size.width-self.width) + self.width;
        newFrame.size.height = point.y*(frame.size.height-self.height) + self.height;
        
        if (cBezier) {
            if (fBezier != cBezier) {
                point = PointOnCubicBezier(cBezier, i*dt);
            }
            if (horizon) {
                newFrame.origin.x = point.x*(frame.origin.x-self.left) + self.left;
            }else{
                newFrame.origin.y = point.x*(frame.origin.y-self.top) + self.top;
            }
        }
        [NSTimer fireDelay:durationTime interval:0 handler:^(CFRunLoopTimerRef timerRef) {
            [self setFrame:newFrame];
            CFRunLoopTimerInvalidate(timerRef);
            if (i == frames-1) {
                if(completion) completion();
                    isRunning = NO;
            }
        }];
    }
}

-(void)showAfterDelay:(NSTimeInterval)delay mode:(HgtAnimateShowMode)mode duration:(NSTimeInterval)duration completion:(void(^)(void))completion{
    static BOOL isRunning;
    if (isRunning) return;
    isRunning = YES;
    self.hidden = YES;
    NSTimeInterval interva = duration/self.width;
    static int i = 0;
    [NSTimer fireDelay:delay interval:interva handler:^(CFRunLoopTimerRef timerRef) {
        self.hidden = NO;
        ++i;
        CGRect rect;
        switch (mode) {
            case HgtAnimateShowModeFromLeft:
                rect = CGRectMake(0, 0, i, self.height);
                break;
            case HgtAnimateShowModeFromRight:
                rect = CGRectMake(self.width-i, 0, i, self.height);
                break;
            case HgtAnimateShowModeFromTop:
                rect = CGRectMake(0, 0, self.width, i);
                break;
            case HgtAnimateShowModeFromBottom:
                rect = CGRectMake(0, self.height-i, self.width, i);
                break;
            case HgtAnimateShowModeFan:
                rect = CGRectZero;
                break;
                
            default:
                rect = CGRectMake(0, 0, i, self.height);
                break;
        }
        
        UIBezierPath *circlePath;
        float starAngle = -M_PI_2;
        float endAngle = -M_PI_2 + i*M_PI*2*interva/(duration);
        if (CGRectEqualToRect(rect, CGRectZero)) {
            circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:((self.width+self.height)/2) startAngle:starAngle endAngle:endAngle clockwise:YES];
            [circlePath addLineToPoint:CGPointMake(self.width/2, self.height/2)];
            [circlePath closePath];
        }else{
            circlePath = [UIBezierPath bezierPathWithRect:rect];
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = circlePath.CGPath;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [[UIColor redColor] CGColor];
        shapeLayer.lineWidth = 2;
        self.layer.mask = shapeLayer;
        
        if (CGRectContainsRect(rect, self.bounds) || (endAngle-starAngle > M_PI*2)) {
            CFRunLoopTimerInvalidate(timerRef);
            i = 0;
            isRunning = NO;
            if(completion) completion();
        }
//        NSLog(@"startAngle=%f,,,endAngle==%f,,,i==%i,,,offset=%f",starAngle/M_PI,endAngle/M_PI,i,endAngle-starAngle - M_PI*2);
    }];
}

//此方法有BUG BUG BUG 废弃屌！！！！
- (UIImage *)changeToImage{
    NSLog(@"=======^^^^^^>%@,,,%@,,,",self,NSStringFromCGRect(self.frame));
    self.backgroundColor = [UIColor whiteColor];
    if (CGRectIsEmpty(self.frame)) {
        return [UIImage imageNamed:@"basketball"];
    }
    UIGraphicsBeginImageContextWithOptions(self.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.layer.contents = nil;
    return capturedImage;
    
    
    
    
//    size_t width = self.bounds.size.width;
//    size_t height = self.bounds.size.height;
//    unsigned char *imageBuffer = (unsigned char *)malloc(width*height*4);
//    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef imageContext = CGBitmapContextCreate(imageBuffer, width, height, 8, width*4, colourSpace,kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
//    CGColorSpaceRelease(colourSpace);
//    [self.layer renderInContext:imageContext];
//    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
//    UIImage *myImage = [UIImage imageWithCGImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
//    CGImageRelease(outputImage);
//    CGContextRelease(imageContext);
//    free(imageBuffer);
//    return myImage;
}

- (UIImage *)changeToImageWithRect:(CGRect)rect{
    UIImage *image = [self changeToImage];
    CGImageRef cr = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    return cropped;
}

#pragma mark - layer
- (void)rounded:(CGFloat)cornerRadius {
    [self rounded:cornerRadius width:0 color:nil];
}

- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor {
    [self rounded:0 width:borderWidth color:borderColor];
}

- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor {
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}


-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset {
    //给Cell设置阴影效果
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}

@end










































