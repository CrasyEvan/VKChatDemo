//
//  NSString_extra.m
//  PAEBank
//
//  Created by pingan_tiger on 11-5-17.
//  Copyright 2011 pingan. All rights reserved.
//

#import "NSString_extra.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(extra)

+ (NSString *)MD5StringFrom:(NSString*)source{
    if(source == nil || [source length] == 0)
        return nil;
    
    const char *value = [source UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
    
}

-(NSString *)milliSecondString2Second{
    if (self.length>10) {
        return [NSString stringWithFormat:@"%lld.%lld",  [self longLongValue]/1000,[self longLongValue]%1000];
    }
    return self;
}

+(NSString *) normaPhoneNumber:(NSString *)number
{    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:number.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:number];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        // --------- Add the following to get out of endless loop
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }   
        // --------- End of addition
    }
    return strippedString;
}
- (NSRange)composedRangeWithRange:(NSRange)range {
    // We're going to make a new range that takes into account surrogate unicode pairs (composed characters)
    __block NSRange adjustedRange = range;
    
    // Adjust the location
    [self enumerateSubstringsInRange:NSMakeRange(0, range.location + 1) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range location.
        // This means that there is a composed character before where the range starts who's length is greater than 1.
        adjustedRange.location += substring.length - 1;
    }];
    
    // Adjust the length
    NSInteger length = self.length;
    // Count how many times we iterate so we only iterate over what we care about.
    __block NSInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(adjustedRange.location, length - adjustedRange.location) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range length.
        // This means that there is a composed character inside of the range starts who's length is greater than 1.
        adjustedRange.length += substring.length - 1;
        
        // Add one to the count
        count++;
        
        // If we have iterated as many times as the original length, stop.
        if (range.length == count) {
            *stop = YES;
        }
    }];
    
    // Make sure we don't make an invalid range. This should never happen, but let's play it safe anyway.
    if (adjustedRange.location + adjustedRange.length > length) {
        adjustedRange.length = length - adjustedRange.location - 1;
    }
    
    // Return the adjusted range
    return adjustedRange;
}
- (NSString *)composedSubstringWithRange:(NSRange)range {
    // Return a substring using a composed range so surrogate unicode pairs (composed characters) count as 1 in the
    // range instead of however many unichars they actually are.
    return [self substringWithRange:[self composedRangeWithRange:range]];
}
- (NSString *)composedStringFromIndex:(int)index{
    NSRange range = NSMakeRange(index, self.length - index);
    return [self substringWithRange:[self composedRangeWithRange:range]];
}
- (NSString *)composedStringToIndex:(int)index{
    NSRange range = NSMakeRange(0, index);
    return [self substringWithRange:[self composedRangeWithRange:range]];
}
+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0,[string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
unsigned char strToChar (char a, char b);
unsigned char strToChar (char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}
- (NSData*) dataFromHex
{
    /*
     NSMutableData *data = [[NSMutableData alloc] init];
     unsigned char whole_byte;
     char byte_chars[3] = {'\0','\0','\0'};
     int i;
     for (i=0; i < 8; i++) {
     byte_chars[0] = [self characterAtIndex:i*2];
     byte_chars[1] = [self characterAtIndex:i*2+1];
     whole_byte = strtol(byte_chars, NULL, 16);
     [data appendBytes:&whole_byte length:1];
     }
     return data;*/
    
    const char * bytes = [self cStringUsingEncoding: NSUTF8StringEncoding];
    NSUInteger length = strlen(bytes);
    unsigned char * r = (unsigned char *) malloc(length / 2 + 1);
    unsigned char * index = r;
    
    while ((*bytes) && (*(bytes +1))) {
        *index = strToChar(*bytes, *(bytes +1));
        index++;
        bytes+=2;
    }
    *index = '\0';
    
    NSData * result = [NSData dataWithBytes: r length: length / 2];
    free(r);
    
    return result;
}
- (NSString *)stringByReversed
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=self.length; i>0; i--) {
        [s appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

@end
