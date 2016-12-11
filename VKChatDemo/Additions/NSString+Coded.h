//
//  NSString+Coded.h
//  Pods
//
//  Created by bolei on 16/1/7.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Coded)

- (NSString *)AES128DecodeWithKey:(NSString *)key;

- (NSString *)AES128EncodeWithKey:(NSString *)key;

@end
