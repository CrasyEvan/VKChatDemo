//
//  NSObject+TypeConvert.m
//  Units
//
//  Created by lingaohe on 9/17/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "NSObject+TypeConvert.h"

@implementation NSObject (TypeConvert)

- (int)intValueWithDefault
{
  if ([self isKindOfClass:[NSString class]]) {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:(NSString *)self];
    return [number intValue];
  }else if ([self isKindOfClass:[NSNumber class]]){
    return [(NSNumber *)self intValue];
  }else if ([self isKindOfClass:[NSNull class]]){
    return 0;
  }
  //默认返回
  return 0;
}
- (long long)longLongValueWithDefault
{
  return [self unsignedLongLongValueWithDefault];
}
- (unsigned long long)unsignedLongLongValueWithDefault
{
  if ([self isKindOfClass:[NSString class]]) {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    unsigned long long ret = [[formatter numberFromString:(NSString *)self] unsignedLongLongValue];
    return ret;
  }else if([self isKindOfClass:[NSNumber class]]){
    unsigned long long ret = [(NSNumber *)self unsignedLongLongValue];
    return ret;
  }
  //
  return 0;
}
- (BOOL)boolValueWithDefault
{
  if ([self isKindOfClass:[NSString class]]) {
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:(NSString *)self];
    return [number boolValue];
  }else if ([self isKindOfClass:[NSNumber class]]){
    return [(NSNumber *)self boolValue];
  }else if ([self isKindOfClass:[NSNull class]]){
    return NO;
  }
  //默认返回
  return NO;
}


@end
