//
//  NSString+sizeWithFontInIOS7.h
//  baiduRouter
//
//  Created by bolei on 14-9-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (sizeWithFontInIOS7)
// Single line, no wrapping. Truncation based on the NSLineBreakMode.

- (CGSize)calculateSizeWithFont:(UIFont *)font NS_AVAILABLE_IOS(7_0);

- (CGSize)calculateSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode NS_AVAILABLE_IOS(7_0);

- (CGSize)calculateSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size NS_AVAILABLE_IOS(7_0); // Uses NSLineBreakModeWordWrap

- (CGSize)calculateSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode NS_AVAILABLE_IOS(7_0); // NSTextAlignment is not needed to determine size

// Single line, no wrapping. Truncation based on the NSLineBreakMode.
- (void)drawAtPointInIOS7:(CGPoint)point withFont:(UIFont *)font NS_AVAILABLE_IOS(7_0);

- (void)drawAtPointInIOS7:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode NS_AVAILABLE_IOS(7_0);

// Wrapping to fit horizontal and vertical size.
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font NS_AVAILABLE_IOS(7_0);
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode NS_AVAILABLE_IOS(7_0);
- (void)drawInRectInIOS7:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment NS_AVAILABLE_IOS(7_0);

@end
