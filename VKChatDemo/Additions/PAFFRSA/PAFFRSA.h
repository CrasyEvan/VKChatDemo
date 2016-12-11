//
//  RSA.h
//  My
//
//  Created by ideawu on 15-2-3.
//  Copyright (c) 2015年 ideawu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAFFRSA : NSObject

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSString *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;


+ (SecKeyRef)addPublicKey:(NSString *)key;

+ (NSString *)encryptWithString:(NSString *)str publicKey:(SecKeyRef)pubKey;

@end
