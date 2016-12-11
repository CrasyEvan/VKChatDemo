//
//  NSDictionary+UrlEncoding.m
//  PANewToapAPP
//
//  Created by pan.zaofeng on 14-10-17.
//  Copyright (c) 2014年 Gavin. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"
#import "NSString+CMUtils.h"


// helper function: get the string form of any object
static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string urlEncodedString];
}

@implementation NSDictionary (UrlEncoding)

-(NSString*) urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

- (NSString *)objectForServerKey:(NSString *)key {
    
    NSString *message = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
    NSString *emptyCase1 = @"<Null>";
    NSString *emptyCase2 = @"(Null)";
    if ([message length] == 0 || [emptyCase1 isEqualToString:message] || [emptyCase2 isEqualToString:message]) {
        
        message = @"";
    }
    
    return message;
}

@end


