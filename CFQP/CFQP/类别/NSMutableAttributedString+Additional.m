//
//  NSMutableAttributedString+Additional.m
//  ShuaYiShua
//
//  Created by Sywine on 9/1/15.
//  Copyright (c) 2015 Sywine. All rights reserved.
//

#import "NSMutableAttributedString+Additional.h"

static NSMutableParagraphStyle *paragraphStyle;
@implementation NSMutableAttributedString (Additional)

-(void)setFont:(UIFont *)font inRange:(NSRange)range{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self addAttributes:dic range:range];
}
-(void)setForegroundColor:(UIColor *)color inRange:(NSRange)range{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [self addAttributes:dic range:range];
}
-(void)setBackgroundColor:(UIColor *)color inRange:(NSRange)range{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:NSBackgroundColorAttributeName];
    [self addAttributes:dic range:range];
}
-(void)setKerning:(float)space inRange:(NSRange)range{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:space] forKey:NSKernAttributeName];
    [self addAttributes:dic range:range];
}
-(void)setStrikethroughStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range{
    NSDictionary *dic = @{NSStrikethroughStyleAttributeName:@(style),NSStrikethroughColorAttributeName:color};
    [self addAttributes:dic range:range];
}
-(void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range{
    NSDictionary *dic = @{NSUnderlineStyleAttributeName:@(style),NSUnderlineColorAttributeName:color};
    [self addAttributes:dic range:range];
}
-(void)setStrokeColor:(UIColor *)color width:(float)width inRange:(NSRange)range{
    NSDictionary *dic = @{NSStrokeColorAttributeName:color,NSStrokeWidthAttributeName:@(width)};
    [self addAttributes:dic range:range];
}
-(void)setTheWritingDirection:(NSArray *)direction inRange:(NSRange)range{
    NSDictionary *dic = @{NSWritingDirectionAttributeName:direction};
    [self addAttributes:dic range:range];
}
-(void)setShadow:(NSShadow *)shadow inRange:(NSRange)range{
    NSDictionary *dic = @{NSShadowAttributeName:shadow};
    [self addAttributes:dic range:range];
}
-(void)setVerticalGlyphForm:(NSNumber *)value inRange:(NSRange)range{
    NSDictionary *dic = @{NSVerticalGlyphFormAttributeName:value};
    [self addAttributes:dic range:range];
}
-(void)setObliqueness:(NSNumber *)value inRange:(NSRange)range{
    NSDictionary *dic = @{NSObliquenessAttributeName:value};
    [self addAttributes:dic range:range];
}
-(void)setExpansion:(NSNumber *)value inRange:(NSRange)range{
    NSDictionary *dic = @{NSExpansionAttributeName:value};
    [self addAttributes:dic range:range];
}

-(void)setLineSpacing:(float)space{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.lineSpacing = space;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setParagraphSpacing:(float)space{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.paragraphSpacing = space;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setAlignment:(NSTextAlignment)alignment{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.alignment = alignment;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setFirstLineHeadIndent:(float)indent{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.firstLineHeadIndent = indent;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setHeadIndent:(float)indent{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.headIndent = indent;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setTailIndent:(float)indent{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.tailIndent = indent;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setLineBreakMode:(NSLineBreakMode)mode{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.lineBreakMode = mode;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setMinimumLineHeight:(float)height{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.minimumLineHeight = height;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setMaximumLineHeight:(float)height{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.maximumLineHeight = height;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setWritingDirection:(NSWritingDirection)direction{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.baseWritingDirection = direction;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setLineHeightMultiple:(float)height{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.lineHeightMultiple = height;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setParagraphSpacingBefore:(float)height{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.paragraphSpacingBefore = height;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}
-(void)setHyphenationFactorBefore:(float)factor{
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    paragraphStyle.hyphenationFactor = factor;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self addAttributes:dic range:NSMakeRange(0, self.length)];
}



@end































