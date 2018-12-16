//
//  InfiniteScrollView.m
//  AGAnnual
//
//  Created by iosdev on 2017/12/15.
//  Copyright © 2017年 iosdev. All rights reserved.
//

#import "InfiniteScrollView.h"
#import <UIImageView+WebCache.h>
#import "BasicScrollView.h"

@implementation InfiniteScrollView {
    BasicScrollView *myScroll;
    NSInteger numOfPages;//多少页
    float shiftInterval;//切页的间隔
    float shiftDuration;//切换动作的时长
    
    BOOL shiftEnable;
    BOOL dragging;
    
    UIView *dotView;
    UIImageView *coverImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        myScroll = [[BasicScrollView alloc]initWithFrame:CGRectMake(0.028*self.width, 0.036*self.height, 0.939*self.width, 0.85*self.height)];
        myScroll.showsHorizontalScrollIndicator = NO;
        myScroll.delegate = self;
        myScroll.pagingEnabled = YES;
        myScroll.bounces = NO;
        [self addSubview:myScroll];
        
        coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        coverImageView.image = [UIImage imageNamed:@"home_frame"];
        [self addSubview:coverImageView];
        
        //加入点点点，提示第几张图片
        dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.91*self.height, self.width, 10)];
        dotView.userInteractionEnabled = NO;
        [self addSubview:dotView];
    }
    return self;
}

- (void)setShiftEnable:(BOOL)enable {
    if (numOfPages < 2) {
        shiftEnable = NO;
        return;
    }
    shiftEnable = enable;
    if (!shiftEnable) {
        [self cancelShiftPerform];
    } else {
        [self performShift];
    }
}

- (void)setupWithPages:(NSArray<UIView *> *)pages
         shiftInterval:(float)interval
         shiftDuration:(float)duration
              callBack:(InfinityBlock)callBack {
    numOfPages = pages.count;
    shiftInterval = interval;
    shiftDuration = duration;
    self.callBack = callBack;
    if (numOfPages > 1) {
        myScroll.contentSize = CGSizeMake(myScroll.width*(numOfPages+2), myScroll.height);
    }
    
    //第一个页面
    UIImage *img0 = [pages.lastObject changeToImage];
    UIImageView *page0 = [[UIImageView alloc]initWithImage:img0];
    page0.frame = CGRectMake(0, 0, myScroll.width, myScroll.height);
    [myScroll addSubview:page0];
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.frame = page0.frame;
    [myScroll addSubview:button0];
    button0.tag = numOfPages - 1;
    [button0 addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间页面
    for (int i = 0 ; i < numOfPages; i++) {
        UIView *page = pages[i];
        page.frame = CGRectMake(myScroll.width*(i+1), 0, myScroll.width, myScroll.height);
        [myScroll addSubview:page];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = page.frame;
        [myScroll addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //最后一个页面
    UIImage *imgX = [pages.firstObject changeToImage];
    UIImageView *pageX = [[UIImageView alloc]initWithImage:imgX];
    pageX.frame = CGRectMake(myScroll.width*(numOfPages+1), 0, myScroll.width, myScroll.height);
    [myScroll addSubview:pageX];
    UIButton *buttonX = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonX.frame = pageX.frame;
    [myScroll addSubview:buttonX];
    buttonX.tag = 0;
    [buttonX addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    myScroll.contentOffset = CGPointMake(myScroll.width, 0);
    
    if (shiftEnable && numOfPages > 1) {
        [self performShift];
    }
    
    //点点点
    [self addDots];
}

- (void)setupWithPageUrls:(NSArray<NSString *> *)urls
            shiftInterval:(float)interval
            shiftDuration:(float)duration
                 callBack:(InfinityBlock)callBack {
    numOfPages = urls.count;
    shiftInterval = interval;
    shiftDuration = duration;
    self.callBack = callBack;
    if (numOfPages > 1) {
        myScroll.contentSize = CGSizeMake(myScroll.width*(numOfPages+2), myScroll.height);
    }
    
    //第一个页面
    NSString *imgLast = urls.lastObject;
    UIImageView *page0 = [[UIImageView alloc]init];
    [page0 sd_setImageWithURL:[NSURL URLWithString:imgLast] placeholderImage:[UIImage imageNamed:@"home_frame2"]];
    page0.frame = CGRectMake(0, 0, myScroll.width, myScroll.height);
    [myScroll addSubview:page0];
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.frame = page0.frame;
    [myScroll addSubview:button0];
    button0.tag = numOfPages - 1;
    [button0 addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间页面
    for (int i = 0 ; i < numOfPages; i++) {
        NSString *url = urls[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"home_frame2"]];
        imageView.frame = CGRectMake(myScroll.width*(i+1), 0, myScroll.width, myScroll.height);
        imageView.layer.cornerRadius = 0.05*imageView.height;
        imageView.layer.masksToBounds = YES;
        [myScroll addSubview:imageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = imageView.frame;
        [myScroll addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //最后一个页面
    NSString *imgFirst = urls.firstObject;
    UIImageView *pageX = [[UIImageView alloc]init];
    [pageX sd_setImageWithURL:[NSURL URLWithString:imgFirst] placeholderImage:[UIImage imageNamed:@"home_frame2"]];
    pageX.frame = CGRectMake(myScroll.width*(numOfPages+1), 0, myScroll.width, myScroll.height);
    [myScroll addSubview:pageX];
    UIButton *buttonX = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonX.frame = pageX.frame;
    [myScroll addSubview:buttonX];
    buttonX.tag = 0;
    [buttonX addTarget:self action:@selector(onPageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    myScroll.contentOffset = CGPointMake(myScroll.width, 0);
    
    if (shiftEnable && numOfPages > 1) {
        [self performShift];
    }
    
    //点点点
    [self addDots];
}

- (void)addDots {
    if (numOfPages < 2) {
        return;
    }
    
    float dwidth = heightTo4_7(20);
    float gap = heightTo4_7(24);
    CGFloat width = dwidth*numOfPages+gap*(numOfPages-1);
    float left = (dotView.width-width)/2;
    
    for (int i = 0; i < numOfPages; i++) {
        UIButton *bbb = [[UIButton alloc] initWithFrame:CGRectMake(left+(dwidth+gap)*i, 0, dwidth, dwidth)];
        [bbb setBackgroundImage:[UIImage imageNamed:@"home_frame0"] forState:0];
        [bbb setBackgroundImage:[UIImage imageNamed:@"home_frame1"] forState:UIControlStateSelected];
        [dotView addSubview:bbb];
        bbb.tag = i;
        bbb.userInteractionEnabled = NO;
        if (i == 0) {
            bbb.selected = YES;
        }
    }
}

//执行一个延时的页面切换
- (void)performShift {
    [self cancelShiftPerform];
    if (numOfPages && shiftEnable) {
        [self performSelector:@selector(shiftThePages) withObject:nil afterDelay:shiftInterval];
    }
}

//执行切换页面动作
- (void)shiftThePages {
    if (dragging) {
        return;
    }
    
    self.userInteractionEnabled = NO;
    [self shiftWithCallback:^{
        self.userInteractionEnabled = YES;
        [self performShift];
    }];
}

//切换动效
- (void)shiftWithCallback:(void (^)(void))block {
    CGPoint offset = myScroll.contentOffset;
    offset.x += myScroll.width;
    __block __weak UIScrollView *scroo = myScroll;
    [UIView animateWithDuration:shiftDuration animations:^{
        scroo.contentOffset = offset;
    } completion:^(BOOL finished) {
        [self adjustScrollOffset];
        block();
    }];
}

//调节页面
- (void)adjustScrollOffset {
    CGPoint offset = myScroll.contentOffset;
    if (offset.x >= myScroll.width*(numOfPages+0.9)) {
        myScroll.contentOffset = CGPointMake(myScroll.width, 0);
    }
    if (offset.x <= 0.1) {
        myScroll.contentOffset = CGPointMake(myScroll.width*numOfPages, 0);
    }
    
    for (UIButton *view in dotView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.selected = NO;
            if (view.tag == ((int)myScroll.contentOffset.x)/((int)myScroll.width)-1) {
                view.selected = YES;
            }
        }
    }
}

//取消执行
- (void)cancelShiftPerform {
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(shiftThePages) object:nil];
}


#pragma mark ButtonEvents
- (void)onPageButton:(UIButton *)button {
    if (self.callBack) {
        self.callBack(button.tag);
    }
}


#pragma mark UIScrollViewDelegate 主要处理用户操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        dragging = NO;
        [self adjustScrollOffset];
        [self performShift];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dragging = NO;
    [self adjustScrollOffset];
    [self performShift];
}

- (void)dealloc {
    [self cancelShiftPerform];
}

@end


















