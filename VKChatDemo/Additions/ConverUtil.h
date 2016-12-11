//
//  ConverUtil.h
//  Pods
//
//  Created by bolei on 15-4-25.
//
//

#import <Foundation/Foundation.h>

@interface ConverUtil : NSObject

/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

@end
