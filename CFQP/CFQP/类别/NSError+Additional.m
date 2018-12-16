//
//  NSError+Additional.m
//  Hgt_Accela_Util
//
//  Created by Sywine on 9/17/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import "NSError+Additional.h"

@implementation NSError (Additional)

+ (NSError *)errorWithTitle:(NSString *)title code:(NSInteger)code otherInfo:(NSDictionary *)otherInfo{
    return [self errorWithTitle:NSStringFromClass([self class]) description:nil code:code otherInfo:otherInfo];
}

+ (NSError *)errorWithTitle:(NSString *)title description:(NSString *)description code:(NSInteger)code otherInfo:(NSDictionary *)otherInfo{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:title forKey:NSLocalizedDescriptionKey];
    [userInfo setObject:description forKey:NSLocalizedFailureReasonErrorKey];
    [userInfo addEntriesFromDictionary:otherInfo];
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:code userInfo:userInfo];
}

@end
