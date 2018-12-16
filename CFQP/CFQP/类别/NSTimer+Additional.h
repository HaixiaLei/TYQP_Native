//
//  NSTimer+Additional.h
//  ShuaYiShua
//
//  Created by Sywine on 9/4/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Additional)

/**
 *  需要在handle中调用CFRunLoopTimerInvalidate(CFRunLoopTimerRef timer)进行终止与释放内存
 *  例：
 *  static int i = 0;
 *  if (i == 15) {
 *  CFRunLoopTimerInvalidate(timeRef);
 *  return ;
 *  }
 */
+ (void)fireDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval handler:(void (^)(CFRunLoopTimerRef timerRef))handler;

@end
