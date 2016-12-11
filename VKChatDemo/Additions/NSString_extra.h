//
//  NSString_extra.h
//  PAEBank
//
//  Created by pingan_tiger on 11-5-17.
//  Copyright 2011 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (extra)
+ (NSString *)MD5StringFrom:(NSString*)source;
+ (NSString *)normaPhoneNumber:(NSString *)number;//电话号码去掉多余的字符
- (NSRange)composedRangeWithRange:(NSRange)range;//处理Emoji表情取长度问题
- (NSString *)composedSubstringWithRange:(NSRange)range;
- (NSString *)composedStringFromIndex:(int)index;
- (NSString *)composedStringToIndex:(int)index;
+(BOOL)isContainsEmoji:(NSString *)string;
-(NSString *)milliSecondString2Second;
- (NSData*) dataFromHex;
- (NSString *)stringByReversed;
@end
