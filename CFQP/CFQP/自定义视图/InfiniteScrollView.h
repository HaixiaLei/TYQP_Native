//
//  InfiniteScrollView.h
//  AGAnnual
//
//  Created by iosdev on 2017/12/15.
//  Copyright © 2017年 iosdev. All rights reserved.
//
//  可以无限左右滑动的scroll，用于年会的上方滚动AD

#import <UIKit/UIKit.h>

typedef void (^InfinityBlock)(NSInteger index);

@interface InfiniteScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic, copy) InfinityBlock callBack;

/* 是否自动轮播，默认不轮播
 */
- (void)setShiftEnable:(BOOL)enable;

/* 初始化方法
 * @para pages 页面数组
 * @para interval 轮播的间隔
 * @para duration 轮播动作的时长
 * @para callback 用户点击了某个页面的回调
 */
- (void)setupWithPages:(NSArray<UIView *> *)pages
         shiftInterval:(float)interval
         shiftDuration:(float)duration
              callBack:(InfinityBlock)callBack;


/* 初始化方法
 * @para pages 页面数组
 * @para interval 轮播的间隔
 * @para duration 轮播动作的时长
 * @para callback 用户点击了某个页面的回调
 */
- (void)setupWithPageUrls:(NSArray<NSString *> *)urls
         shiftInterval:(float)interval
         shiftDuration:(float)duration
              callBack:(InfinityBlock)callBack;

@end
