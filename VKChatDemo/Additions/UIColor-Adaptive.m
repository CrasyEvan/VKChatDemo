//
//  UIColor-Adaptive.m
//  baiduHi
//
//  Created by Steve Jobs on 3/5/12.
//  Copyright (c) 2012 Baidu. All rights reserved.
//

#import "UIColor-Adaptive.h"

@implementation UIColor (Adaptive)

+ (UIColor *)colorWithHex:(NSInteger)hex
{
    return [UIColor colorWithHex:hex
                           alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hex & 0XFF0000) >> 16) / 255.0
                           green:((hex & 0X00FF00) >> 8)  / 255.0
                            blue:(hex & 0X0000FF)         / 255.0
                           alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
    case 3: // #RGB
        alpha = 1.0f;
        red = [self colorComponentFrom:colorString start:0 length:1];
        green = [self colorComponentFrom:colorString start:1 length:1];
        blue = [self colorComponentFrom:colorString start:2 length:1];
        break;
    case 4: // #ARGB
        alpha = [self colorComponentFrom:colorString start:0 length:1];
        red = [self colorComponentFrom:colorString start:1 length:1];
        green = [self colorComponentFrom:colorString start:2 length:1];
        blue = [self colorComponentFrom:colorString start:3 length:1];
        break;
    case 6: // #RRGGBB
        alpha = 1.0f;
        red = [self colorComponentFrom:colorString start:0 length:2];
        green = [self colorComponentFrom:colorString start:2 length:2];
        blue = [self colorComponentFrom:colorString start:4 length:2];
        break;
    case 8: // #AARRGGBB
        alpha = [self colorComponentFrom:colorString start:0 length:2];
        red = [self colorComponentFrom:colorString start:2 length:2];
        green = [self colorComponentFrom:colorString start:4 length:2];
        blue = [self colorComponentFrom:colorString start:6 length:2];
        break;
    default:
        return nil;
        break;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
