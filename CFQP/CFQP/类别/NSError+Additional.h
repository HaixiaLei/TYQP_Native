//
//  NSError+Additional.h
//  Hgt_Accela_Util
//
//  Created by Sywine on 9/17/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Additional)

+ (NSError *)errorWithTitle:(NSString *)title code:(NSInteger)code otherInfo:(NSDictionary *)otherInfo;

+ (NSError *)errorWithTitle:(NSString *)title description:(NSString *)description code:(NSInteger)code otherInfo:(NSDictionary *)otherInfo;

@end
