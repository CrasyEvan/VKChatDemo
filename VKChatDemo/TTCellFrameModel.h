//
//  TTReceiveCellViewModel.h
//  VKChatDemo
//
//  Created by Evan on 2016/12/11.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EaseMob.h"

@interface TTCellFrameModel : NSObject

@property (nonatomic, assign) CGRect avatorF;
@property (nonatomic, assign) CGRect messageLabelF;
@property (nonatomic, assign) CGSize bubbleImageSize;
@property (nonatomic, assign) CGRect senderMessageViewF;

/** 消息模型，内部set方法 显示文字 */
@property (nonatomic, strong) EMMessage *message;

/** 行高 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


/**
 初始化FrameModel对象

 @param emMessage 数据模型数组
 @return 返回FrameModels 用于实例化TableView
 */
+ (NSMutableArray *)initWithMessage:(NSMutableArray *)emMessage;

/**
 消息增量

 @param targetMessage 新增的消息
 @return frameModel
 */
+ (TTCellFrameModel *)addFrameModelwithTargetMessage:(EMMessage *)targetMessage;
@end
