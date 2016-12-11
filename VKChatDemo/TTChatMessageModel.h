//
//  TTChatMessage.h
//  VKChatDemo
//
//  Created by Evan on 2016/12/9.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTChatMessageModel : NSObject

@property (nonatomic,assign) NSNumber *messageType;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *timestamp;


@end
