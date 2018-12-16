//
//  NSString+Additional.m
//  ShowMessage
//
//  Created by Heguiting on 8/17/15.
//  Copyright (c) 2015 Heguiting. All rights reserved.
//

#import "NSString+Additional.h"

@implementation NSString (Additional)

-(NSDictionary *) dictionaryValue{
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"Fail to get dictioanry from String: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

-(NSArray *) arrayValue{
    NSError *errorJson;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"Fail to get array from String: %@, error: %@", self, errorJson);
#endif
    }
    return jsonArr;
}

- (BOOL)containString:(NSString *)target {
    if (target == nil) {
        return NO;
    }
    NSRange range = [self rangeOfString:target];
    if (range.length > 0) {
        return YES;
    }
    
    return NO;
}

-(CGSize)getContentSizeWithFont:(UIFont *)font andWidth:(CGFloat)w andHeight:(CGFloat)h
{
#ifdef NSFoundationVersionNumber_iOS_7_0
    return [self boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : font} context:nil].size;
#else
    return  [self sizeWithFont:font constrainedToSize:CGSizeMake(w, h) lineBreakMode:NSLineBreakByWordWrapping];
#endif
}

#pragma mark 是否是有效的Email
- (BOOL)isEffectiveEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

#pragma mark 判断是否是URL
- (BOOL)isEffectiveUrl {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

+ (NSString *)AppVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)BundleIdentifier{
    NSString *bundleIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}

+ (NSString *)BuildVersion{
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return bundleVersion;
}

+ (NSString *)SystemTimeZone{
    NSString *timeZone = [[NSTimeZone systemTimeZone] name];
    return timeZone;
}

+ (NSString *)SystemLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]){
        return @"zh";
    }
    else if ([currentLanguage isEqualToString:@"zh-Hant"]){
        return @"zh_TW";
    }
    else if ([currentLanguage isEqualToString:@"zh-Hant-HK"]){
        return @"zh_HK";
    }
    return currentLanguage;
}

+ (NSString *)CountryCode{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)DocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

+ (NSString *)CachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

+ (NSString *)TmpPath{
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

+ (NSString *)dd_formatPrice:(NSNumber *)price{
    price = @(price.floatValue);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
//        formatter.positiveFormat = @"###,##0.00;";
    return [NSString stringWithFormat:@"￥%@",[formatter stringFromNumber:price]];
}

/**
 *  去掉金额前面的0
 */
- (NSString *)removeFrontZeros {
    NSString *string = [NSString stringWithString:self];
    while ([string hasPrefix:@"0"] && string.length > 1) {
         string = [string substringFromIndex:1];
    }
    if (string.length < 1) {
        string = @"0";
    }
    return string;
}

- (NSString *)addMoneyDot {
    // 判断是否null 若是赋值为0 防止崩溃
    if (([self isEqual:[NSNull null]] || self == nil)) {
        return @"0";
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
    if ([money containString:@"."]) {
        if ([money rangeOfString:@"."].location == (money.length-2)) {
            money = [money stringByAppendingString:@"0"];
        }
    } else {
        money = [money stringByAppendingString:@".00"];
    }
    return money;
}

- (NSString *)addMoneyDotNoFloat {
    // 判断是否null 若是赋值为0 防止崩溃
    if (([self isEqual:[NSNull null]] || self == nil)) {
        return @"0";
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
    return money;
}

@end
