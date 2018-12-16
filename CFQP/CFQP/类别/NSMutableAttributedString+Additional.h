//
//  NSMutableAttributedString+Additional.h
//  ShuaYiShua
//
//  Created by Sywine on 9/1/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Additional)

-(void)setFont:(UIFont *)font inRange:(NSRange)range;//字体
-(void)setForegroundColor:(UIColor *)color inRange:(NSRange)range;//字颜色
-(void)setBackgroundColor:(UIColor *)color inRange:(NSRange)range;//字背景颜色
-(void)setKerning:(float)space inRange:(NSRange)range;//字间距
-(void)setStrikethroughStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range;//删除线
-(void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range;//下划线
-(void)setStrokeColor:(UIColor *)color width:(float)width inRange:(NSRange)range;//空心字

//NSWritingDirectionAttributeName 设置文字书写方向，取值为以下组合
//@[@(NSWritingDirectionLeftToRight | NSTextWritingDirectionEmbedding)]
//@[@(NSWritingDirectionLeftToRight | NSTextWritingDirectionOverride)]
//@[@(NSWritingDirectionRightToLeft | NSTextWritingDirectionEmbedding)]
//@[@(NSWritingDirectionRightToLeft | NSTextWritingDirectionOverride)]
-(void)setTheWritingDirection:(NSArray *)direction inRange:(NSRange)range;//书写方向

-(void)setShadow:(NSShadow *)shadow inRange:(NSRange)range;//阴影，与下面三个共同使用效果更佳
-(void)setVerticalGlyphForm:(NSNumber *)value inRange:(NSRange)range;//NSNumber 对象(整数)。0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义。
-(void)setObliqueness:(NSNumber *)value inRange:(NSRange)range;//nsnumber 倾斜度
-(void)setExpansion:(NSNumber *)value inRange:(NSRange)range;//nsnumber 膨胀度


/**
 *  设置段落属性
 */
-(void)setLineSpacing:(float)space;//行间距
-(void)setParagraphSpacing:(float)space;//段落间距
-(void)setAlignment:(NSTextAlignment)alignment;//对齐方式
-(void)setFirstLineHeadIndent:(float)indent;//首行缩紧
-(void)setHeadIndent:(float)indent;//头缩进
-(void)setTailIndent:(float)indent;//尾缩进
-(void)setLineBreakMode:(NSLineBreakMode)mode;//削减方式
-(void)setMinimumLineHeight:(float)height;//最小行高
-(void)setMaximumLineHeight:(float)height;//最大行高
-(void)setWritingDirection:(NSWritingDirection)direction;//文字方向
-(void)setLineHeightMultiple:(float)height;//行高
-(void)setParagraphSpacingBefore:(float)height;//首段与前面的距离
-(void)setHyphenationFactorBefore:(float)factor;//断字因素
@end










