//
//  UIColor-Adaptive.h
//  baiduHi
//
//  Created by Steve Jobs on 3/5/12.
//  Copyright (c) 2012 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@interface UIColor (Adaptive)

+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
