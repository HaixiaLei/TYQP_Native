//
//  NSArray+Additional.h
//  ShowMessage
//
//  Created by Heguiting on 8/17/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additional)

/**
 *  转化为json格式
 */
- (NSString *)JSONString;

/**
 *  安全返回数组元素，当数组越界返回nil
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;
- (NSArray *)arrayAtIndex:(NSUInteger)index;
- (NSNumber *)numberAtIndex:(NSUInteger)index;
- (NSString *)stringAtIndex:(NSUInteger)index;

- (NSInteger)integerAtIndex:(NSUInteger)index;
- (float)floatAtIndex:(NSUInteger)index;



@end
