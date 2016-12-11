//
//  RSAEcryptor.h
//  RSATest
//
//  Created by monster on 14/11/25.
//  Copyright (c) 2014年 monster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAFFRSAEncryptor : NSObject



#pragma mark - Instance Methods

-(void) loadPublicKeyFromFile: (NSString*) derFilePath;
-(void) loadPublicKeyFromData: (NSData*) derData;

-(void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
-(void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;




-(NSString*) rsaEncryptString:(NSString*)string;
-(NSData*) rsaEncryptData:(NSData*)data ;

-(NSString*) rsaDecryptString:(NSString*)string;
-(NSData*) rsaDecryptData:(NSData*)data;





#pragma mark - Class Methods

+(PAFFRSAEncryptor*) sharedInstance;

@end
