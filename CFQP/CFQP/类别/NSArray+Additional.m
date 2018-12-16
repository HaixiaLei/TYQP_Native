//
//  NSArray+Additional.m
//  ShowMessage
//
//  Created by Heguiting on 8/17/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import "NSArray+Additional.h"
#import "NSString+Additional.h"
#import "NSDictionary+Additional.h"

@implementation NSArray (Additional)

- (NSString *)JSONString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"Fail to get JSON from array: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return nil;
    }else{
        return [self objectAtIndex:index];
    }
}
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return nil;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return obj;
        }else if ([obj isKindOfClass:[NSString class]]){
            NSString *str = (NSString *)obj;
            return [str dictionaryValue];
        }
        else{
            return nil;
        }
    }
}
- (NSArray *)arrayAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return nil;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSArray class]]) {
            return obj;
        }else if ([obj isKindOfClass:[NSString class]]){
            NSString *str = (NSString *)obj;
            return [str arrayValue];
        }
        else{
            return nil;
        }
    }
}
- (NSNumber *)numberAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return nil;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSNumber class]]) {
            return obj;
        }else if ([obj isKindOfClass:[NSString class]]){
            NSString *str = (NSString *)obj;
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            return [numberFormatter numberFromString:str];
        }
        else{
            return nil;
        }
    }
}
- (NSString *)stringAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return nil;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }else if ([obj isKindOfClass:[NSNumber class]]){
            NSNumber *num = (NSNumber *)obj;
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            return [numberFormatter stringFromNumber:num];
        }else if ([obj isKindOfClass:[NSArray class]]){
            NSArray *arr = (NSArray *)obj;
            return [arr JSONString];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic = (NSDictionary *)obj;
            return [dic JSONString];
        }
        else{
            return nil;
        }
    }
}
- (NSInteger)integerAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return -100000;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)obj;
            return [num integerValue];
        }else if ([obj isKindOfClass:[NSString class]]){
            NSString *str = (NSString *)obj;
            return [str integerValue];
        }
        else{
            return -100000;
        }
    }
}
- (float)floatAtIndex:(NSUInteger)index{
    if (index > self.count-1) {
        return -100000;
    }else{
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)obj;
            return [num floatValue];
        }else if ([obj isKindOfClass:[NSString class]]){
            NSString *str = (NSString *)obj;
            return [str floatValue];
        }
        else{
            return -100000;
        }
    }
}
@end


















