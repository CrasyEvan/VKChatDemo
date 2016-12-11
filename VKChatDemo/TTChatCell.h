//
//  TTSenderChatCell.h
//  VKChatDemo
//
//  Created by Evan on 2016/12/9.
//  Copyright © 2016年 Evan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EaseMob.h"
#import "TTCellFrameModel.h"

@interface TTChatCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avator;
@property (nonatomic, strong) UIImageView *senderMessageView;
@property (nonatomic, strong) UILabel *messageLabel;

/** 消息模型，内部set方法 显示文字 */
//@property (nonatomic, strong) EMMessage *message;

@property (nonatomic, strong) TTCellFrameModel *frameModel;



@end
