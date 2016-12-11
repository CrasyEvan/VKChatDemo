//
//  NSData+MD5.h
//  baohe
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(MD5)

- (NSString *)MD5;

/*
 *hash_hamc算法
 */
- (NSData*)dataByHmacSHA1EncryptingWithKey:(NSData*)key;

@end
