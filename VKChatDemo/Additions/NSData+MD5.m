//
//  NSData+MD5.m
//  baohe
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData(MD5)

-(NSString*)MD5{
	const char *cStr = [self bytes];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)[self length], digest );
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 digest[0], digest[1], 
                 digest[2], digest[3],
                 digest[4], digest[5],
                 digest[6], digest[7],
                 digest[8], digest[9],
                 digest[10], digest[11],
                 digest[12], digest[13],
                 digest[14], digest[15]];
	return s;
	
}

- (NSData*)dataByHmacSHA1EncryptingWithKey:(NSData*)key
{
  void* buffer = malloc(CC_SHA1_DIGEST_LENGTH);
  CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [self bytes], [self length], buffer);
  return [NSData dataWithBytesNoCopy:buffer length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}
@end
