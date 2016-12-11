//
//  NSString+sizeWithFontInIOS7.m
//  baiduRouter
//
//  Created by bolei on 14-9-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "NSString+sizeWithFontInIOS7.h"


@implementation NSString (sizeWithFontInIOS7)

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (CGSize)calculateSizeWithFont:(UIFont *)font
{
    return [self calculateSizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight) lineBreakMode:NSLineBreakByTruncatingTail];
}
- (CGSize)calculateSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self calculateSizeWithFont:font constrainedToSize:CGSizeMake(width, font.lineHeight) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)calculateSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self calculateSizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}
- (CGSize)calculateSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode 
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize calculateSize = [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return calculateSize;
}

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (void)drawAtPointInIOS7:(CGPoint)point withFont:(UIFont *)font 
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    [self drawAtPoint:point withAttributes:attributes];
}
- (void)drawAtPointInIOS7:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode  
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    [self drawInRect:CGRectMake(point.x, point.y, width, font.lineHeight) withAttributes:attributes];
}

// Wrapping to fit horizontal and vertical size.
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font
{
    [self drawInRectInIOS7:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
}
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode 
{
    [self drawInRectInIOS7:rect withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    [self drawInRect:rect withAttributes:attributes];
}

@end
