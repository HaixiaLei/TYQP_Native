//
//  QQButton.m
//  QQBtn
//
//  Created by MacBook on 15/6/25.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#define kBtnWidth self.bounds.size.width
#define kBtnHeight self.bounds.size.height

#import "QQButton.h"

@interface QQButton()

/** 绘制不规则图形 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation QQButton

- (void)setCount:(NSInteger)count {
    [self setTitle:[NSString stringWithFormat:@"%li",count] forState:UIControlStateNormal];
//    
//    UILabel *num = [[UILabel alloc] initWithFrame:self.bounds];
//    num.textColor = self.titleLabel.textColor;
//    num.font = self.titleLabel.font;
//    num.textAlignment = NSTextAlignmentCenter;
//    num.text = self.titleLabel.text;
//    [self addSubview:num];
//    
//    UIImage *image = [num changeToImage];
//    [num removeFromSuperview];
//    UIImageView *imagev = [[UIImageView alloc] initWithFrame:self.bounds];
//    [self addSubview:imagev];
//    imagev.image = image;
//    [UIView animateWithDuration:0.13 animations:^{
//        imagev.frame = CGRectInset(imagev.frame, -0.25*imagev.width, -0.25*imagev.height);
//        imagev.alpha = 0.2;
//    } completion:^(BOOL finished) {
//        [imagev removeFromSuperview];
//    }];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [_samllCircleView setHidden:hidden];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self setUp];
//}

//- (void)layoutSubviews
//{
//    [self setUp];
//}

#pragma mark - 懒加载
- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = @[[UIImage imageNamed:@"QQbutton0"],[UIImage imageNamed:@"QQbutton1"],];
    }
    return _images;
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    
    return _shapeLayer;
}

- (UIView *)samllCircleView
{
    if (!_samllCircleView) {
        _samllCircleView = [[UIView alloc] init];
        _samllCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:_samllCircleView belowSubview:self];
    }
    
    return _samllCircleView;
}

- (void)setUp
{
    CGFloat cornerRadius = (kBtnHeight > kBtnWidth ? kBtnWidth / 2.0 : kBtnHeight / 2.0);
    self.backgroundColor = [UIColor grayColor];
//    self.backgroundColor = [UIColor redColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:self.frame.size.width/1.7];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _maxDistance = cornerRadius * 6;

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    
    CGRect samllCireleRect = CGRectMake(0, 0, cornerRadius * (2 - 0.5) , cornerRadius * (2 - 0.5));
    self.samllCircleView.bounds = samllCireleRect;
    _samllCircleView.center = self.center;
    _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    if (!_samllCircleView.superview) {
        [self.superview insertSubview:_samllCircleView belowSubview:self];
    }
    
    [self.layer removeAnimationForKey:@"shake"];

    CGPoint panPoint = [pan translationInView:self];

    CGPoint changeCenter = self.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.center = changeCenter;
    [pan setTranslation:CGPointZero inView:self];
    
    //俩个圆的中心点之间的距离
    CGFloat dist = [self pointToPoitnDistanceWithPoint:self.center potintB:self.samllCircleView.center];
    
    if (dist < _maxDistance) {
        
        CGFloat cornerRadius = (kBtnHeight > kBtnWidth ? kBtnWidth / 2 : kBtnHeight / 2);
        CGFloat samllCrecleRadius = cornerRadius - dist / 8.5;
        _samllCircleView.bounds = CGRectMake(0, 0, samllCrecleRadius * (2.15 - 0.5), samllCrecleRadius * (2.15 - 0.5));
        _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
        
        if (_samllCircleView.hidden == NO && dist > 0) {
            //画不规则矩形
            self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:_samllCircleView].CGPath;
        }
    } else {
        
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        
        self.samllCircleView.hidden = YES;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (dist > _maxDistance) {
            
            //播放销毁动画
            [self startDestroyAnimations];
            
            //销毁全部控件
            [self killAll];
            
        } else {
            
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = self.samllCircleView.center;
            } completion:^(BOOL finished) {
                self.samllCircleView.hidden = NO;
            }];
        }
    }
}

#pragma mark - 俩个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB
{
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    
    return dist;
}

- (void)killAll
{
    __weak typeof(self) ws = self;
    if (ws.qqBtnDelegate) {
        [ws.qqBtnDelegate QQButtonWiddRemoved];
    }
    [self removeFromSuperview];
    [self.samllCircleView removeFromSuperview];
    self.samllCircleView = nil;
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
}

#pragma mark - 不规则路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat d = [self pointToPoitnDistanceWithPoint:self.samllCircleView.center potintB:self.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

#pragma mark - button消失动画
- (void)startDestroyAnimations
{
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.frame, -0.2*self.frame.size.width, -0.2*self.frame.size.width)];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.3;
    [ainmImageView startAnimating];
    [self.superview addSubview:ainmImageView];
    [ainmImageView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.31];
}

- (void)btnClick
{
    if ([self.qqBtnDelegate respondsToSelector:@selector(QQButtonPressed)]) {
        [self.qqBtnDelegate QQButtonPressed];
    } else {
        [self startDestroyAnimations];
        [self killAll];
    }
}

//#pragma mark - 设置长按时候左右摇摆的动画
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [self.layer removeAnimationForKey:@"shake"];
//
//    //长按左右晃动的幅度大小
//    CGFloat shake = self.width*0.22;
//    
//    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
//    keyAnim.keyPath = @"transform.translation.x";
//    keyAnim.values = @[@(-shake), @(shake), @(-shake)];
//    keyAnim.removedOnCompletion = NO;
//    keyAnim.repeatCount = MAXFLOAT;
//    keyAnim.repeatCount = 3;
//    //左右晃动一次的时间
//    keyAnim.duration = 0.3;
//    [self.layer addAnimation:keyAnim forKey:@"shake"];
//}

@end
