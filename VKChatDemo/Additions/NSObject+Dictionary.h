//
//  NSObject+Dictionary.h
//  baiduRouter
//
//  Created by bolei on 14-2-28.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Dictionary)

- (void)setPropertiesFromDictionary:(NSDictionary *)dict;

- (NSDictionary *)getPropertiesDictionary; //将所有成员转换未字典

@end
