//
//  NSObject+TypeConvert.h
//  Units
//
//  Created by lingaohe on 9/17/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TypeConvert)

- (int)intValueWithDefault;
- (long long)longLongValueWithDefault;
- (unsigned long long)unsignedLongLongValueWithDefault;
- (BOOL)boolValueWithDefault;

@end
