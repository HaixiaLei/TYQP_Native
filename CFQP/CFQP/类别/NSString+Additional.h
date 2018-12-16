//
//  NSString+Additional.h
//  ShowMessage
//
//  Created by Heguiting on 8/17/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Additional)

/**
 *  转化为字典
 */
-(NSDictionary *) dictionaryValue;

/**
 *  转化为数组
 */
-(NSArray *) arrayValue;

/**
 *  是否包含string
 */
- (BOOL)containString:(NSString *)target;

/**
 *  获取string在某个状态下的size
 */
-(CGSize)getContentSizeWithFont:(UIFont *)font andWidth:(CGFloat)w andHeight:(CGFloat)h;

/**
 *  是否是有效的邮件
 */
- (BOOL)isEffectiveEmail;

/**
 *  是否是有效的url地址
 */
- (BOOL)isEffectiveUrl;

/**
 *  返回系统信息
 */
+ (NSString *)AppVersion;
+ (NSString *)BundleIdentifier;
+ (NSString *)BuildVersion;
+ (NSString *)SystemTimeZone;
+ (NSString *)SystemLanguage;
+ (NSString *)CountryCode;

/**
 *  路径
 */
+ (NSString *)DocumentsPath;
+ (NSString *)CachesPath;
+ (NSString *)TmpPath;

/**
 *  转化为价格
 */
+ (NSString *)dd_formatPrice:(NSNumber *)price;

/**
 *  去掉金额前面的0
 */
- (NSString *)removeFrontZeros;

//在金额里加逗号
- (NSString *)addMoneyDot;
- (NSString *)addMoneyDotNoFloat;
@end























