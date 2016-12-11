//
//  RSA.m
//  My
//
//  Created by ideawu on 15-2-3.
//  Copyright (c) 2015年 ideawu. All rights reserved.
//

#import "PAFFRSA.h"
#import <Security/Security.h>
#import "GTMBase64.h"

@implementation PAFFRSA

/*
static NSString *base64_encode(NSString *str){
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	if(!data){
		return nil;
	}
	return base64_encode_data(data);
}
*/

static NSString *base64_encode_data(NSData *data){
    
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        data = [data base64EncodedDataWithOptions:0];
    }else{
        data = [GTMBase64 encodeData:data];
    }

	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return ret;
}

static NSData *base64_decode(NSString *str){
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
	return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
	// Skip ASN.1 public key header
	if (d_key == nil) return(nil);
	
	unsigned long len = [d_key length];
	if (!len) return(nil);
	
	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx    = 0;
	
	if (c_key[idx++] != 0x30) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	// PKCS #1 rsaEncryption szOID_RSA_RSA
	static unsigned char seqiod[] =
	{ 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
		0x01, 0x05, 0x00 };
	if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
	
	idx += 15;
	
	if (c_key[idx++] != 0x03) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	if (c_key[idx++] != '\0') return(nil);
	
	// Now make a new NSData from this buffer
	return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
	NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
	NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
	if(spos.location != NSNotFound && epos.location != NSNotFound){
		NSUInteger s = spos.location + spos.length;
		NSUInteger e = epos.location;
		NSRange range = NSMakeRange(s, e-s);
		key = [key substringWithRange:range];
	}
	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
	
	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
//    NSData *data = [key dataUsingEncoding:NSUTF8StringEncoding];
	data = [PAFFRSA stripPublicKeyHeader:data];
	if(!data){
		return nil;
	}
	
	NSString *tag = @"what_the_fuck_is_this";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
	
	// Delete any old lingering key with the same tag
	NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
	[publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)publicKey);
	
	// Add persistent version of the key to system keychain
	[publicKey setObject:data forKey:(__bridge id)kSecValueData];
	[publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
	 kSecAttrKeyClass];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];
	
	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[publicKey removeObjectForKey:(__bridge id)kSecValueData];
	[publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
    CFDictionaryRef publicKeyRef = (CFDictionaryRef)CFBridgingRetain(publicKey);
	status = SecItemCopyMatching(publicKeyRef, (CFTypeRef *)&keyRef);
    CFRelease(publicKeyRef);
	if(status != noErr){
		return nil;
	}
    
	return keyRef;
}

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	return [PAFFRSA encryptData:data publicKey:pubKey];
}

+ (NSString *)encryptWithString:(NSString *)str publicKey:(SecKeyRef)pubKey{
    
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if(!data || !pubKey){
        return nil;
    }
    
    SecKeyRef keyRef = pubKey;
    
    if(!keyRef){
        return nil;
    }
    
    //	const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    //	size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    
    NSString *ret = nil;
    
    // 分配内存块, 用于存放要加密的数据段
    uint8_t *cipherBuffer = malloc(outlen * sizeof(uint8_t));
    
    /*
     为什么这里要减12而不是减11?
     苹果官方文档给出的说明是，加密时，如果sec padding使用的是kSecPaddingPKCS1，
     那么支持的最长加密长度为SecKeyGetBlockSize()-11，
     这里说的最长加密长度，我估计是包含了字符串最后的空字符'\0'，
     因为在实际应用中我们是不考虑'\0'的，所以，支持的真正最长加密长度应为SecKeyGetBlockSize()-12
     */
    size_t blockSize = outlen - 12;
    
    // 分段的count
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    
    //后面分段处理的data
    NSMutableData *encryptedData = [NSMutableData data];
    
    // 分段加密
    for (NSUInteger i = 0; i < blockCount; i++) {
        
        NSUInteger loc = i * blockSize;
        
        // 数据段的实际大小。最后一段可能比blockSize小。
        NSUInteger bufferSize = MIN(blockSize,[data length] - loc);
        
        // 截取需要加密的数据段
        NSData *buffer = [data subdataWithRange:NSMakeRange(loc, bufferSize)];
        
        // status 加密的结果  seckeyEncrypt 加密
        OSStatus status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &outlen);
        
        if (status == noErr) {
            
            //加密后的data
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:outlen];
            // 追加加密后的数据段
            [encryptedData appendData:encryptedBytes];
        }else {
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    
    ret = base64_encode_data(encryptedData);
    free(cipherBuffer);
    CFRelease(keyRef);
    return ret;


}

+ (NSString *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
	if(!data || !pubKey){
		return nil;
	}
    
     SecKeyRef keyRef = [PAFFRSA addPublicKey:pubKey];

	if(!keyRef){
		return nil;
	}

//	const uint8_t *srcbuf = (const uint8_t *)[data bytes];
//	size_t srclen = (size_t)data.length;

	size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    
    NSString *ret = nil;
    
    // 分配内存块, 用于存放要加密的数据段
    uint8_t *cipherBuffer = malloc(outlen * sizeof(uint8_t));
    
    /*
     为什么这里要减12而不是减11?
     苹果官方文档给出的说明是，加密时，如果sec padding使用的是kSecPaddingPKCS1，
     那么支持的最长加密长度为SecKeyGetBlockSize()-11，
     这里说的最长加密长度，我估计是包含了字符串最后的空字符'\0'，
     因为在实际应用中我们是不考虑'\0'的，所以，支持的真正最长加密长度应为SecKeyGetBlockSize()-12
     */
    size_t blockSize = outlen - 12;
    
    // 分段的count
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    
    //后面分段处理的data
    NSMutableData *encryptedData = [NSMutableData data];

    // 分段加密
    for (NSUInteger i = 0; i < blockCount; i++) {
        
        NSUInteger loc = i * blockSize;
        
        // 数据段的实际大小。最后一段可能比blockSize小。
        NSUInteger bufferSize = MIN(blockSize,[data length] - loc);
        
        // 截取需要加密的数据段
        NSData *buffer = [data subdataWithRange:NSMakeRange(loc, bufferSize)];
        
        // status 加密的结果  seckeyEncrypt 加密
        OSStatus status = SecKeyEncrypt(keyRef, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &outlen);
        
        if (status == noErr) {
            
            //加密后的data
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:outlen];
            // 追加加密后的数据段
            [encryptedData appendData:encryptedBytes];
        }else {
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    
    ret = base64_encode_data(encryptedData);
    free(cipherBuffer);
    CFRelease(keyRef);
    return ret;
}



@end
