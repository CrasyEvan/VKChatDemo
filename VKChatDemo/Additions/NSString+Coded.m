//
//  NSString+Coded.m
//  Pods
//
//  Created by bolei on 16/1/7.
//
//

#import "NSString+Coded.h"
#import "NSString+CMUtils.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NSString+URLEncode.h"


@implementation NSString (Coded)

- (NSString *)AES128DecodeWithKey:(NSString *)key {
    if ([key length] > 0 && [self length] > 0) {
        
        NSString *result = [self URLDecode];
        NSData *encryptedData = [GTMBase64 decodeString:result];
        
        return [NSString AES128DecodeWithData:encryptedData key:key];
    }
    return nil;
}

- (NSString *)AES128EncodeWithKey:(NSString *)key {
    if ([key length] > 0 && [self length] > 0) {
        
        NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encryptedData = [NSString AES128EncryptWithData:plainData key:key];
        encryptedData = [GTMBase64 encodeData:encryptedData];
        NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
        encryptedString = [encryptedString URLEncode];
        return encryptedString;
    }
    return nil;
}



+ (NSString *)AES128DecodeWithData:(NSData *)encryptedData key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1]; //保证key为128位
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [encryptedData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus =
    CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCKeySizeAES128,
            NULL, [encryptedData bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *plainData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

+ (NSData *)AES128EncryptWithData:(NSData *)encryptedData key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1]; //保证key为128位
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [encryptedData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL,
                                          [encryptedData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


@end
