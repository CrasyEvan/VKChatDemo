//
//  NSObject+Dictionary.m
//  baiduRouter
//
//  Created by bolei on 14-2-28.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "NSObject+Dictionary.h"
#import <objc/runtime.h>
#import "NSObject+ClassName.h"

@implementation NSObject (Dictionary)

- (void)setPropertiesFromDictionary:(NSDictionary *)dict
{
    unsigned int propCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propCount);
    [self setPropertiesFromDictionary:dict propertyList:properties propCount:propCount];
    if ([[self superclass] isSubclassOfClass:[NSObject class]]) {
        propCount = 0;
        objc_property_t *superProperties = class_copyPropertyList(self.superclass, &propCount);
        [self setPropertiesFromDictionary:dict propertyList:superProperties propCount:propCount];
    }
    /**
    objc_property_t* properties = class_copyPropertyList([self class], &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if(propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [dict objectForKey:name];
            if (!obj)
                continue;
            if ([[obj className] isEqualToString:@"__NSCFString"] || [[obj className] isEqualToString:@"__NSCFNumber"]) {
                [self setValue:obj forKeyPath:name];
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                id subObj = [self valueForKey:name];
                if (subObj)
                    [subObj setPropertiesFromDictionary:obj];
            }
        }
    }
    free(properties);
    **/
}

- (void)setPropertiesFromDictionary:(NSDictionary *)dict propertyList:(objc_property_t *)properties propCount:(unsigned int)propCount
{
    unsigned int i;
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if (propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [dict objectForKey:name];
            if (!obj)
                continue;
            if ([[obj className] isEqualToString:@"__NSCFString"] || [[obj className] isEqualToString:@"__NSCFNumber"] || [[obj className] isEqualToString:@"__NSCFConstantString"] || [[obj className] isEqualToString:@"__NSArrayM"]) {
                [self setValue:obj forKeyPath:name];
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                id subObj = [self valueForKey:name];
                if (subObj)
                    [subObj setPropertiesFromDictionary:obj];
            }
        }
    }
    free(properties);
}

- (NSDictionary *)getPropertiesDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t prop = properties[i];
        const char *propName = property_getName(prop);
        if (propName) {
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id obj = [self valueForKey:name];
            if (!obj)
                continue;
            [dic setObject:obj forKey:name];
        }
    }
    free(properties);
    return dic;
}

@end
