
//
//  TTSenderChatCell.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/9.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTChatCell.h"
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kText_Font [UIFont systemFontOfSize:14]
#define kUserName @"vanke03"


@interface TTChatCell ()

@end

@implementation TTChatCell


- (UIImageView *)senderAvator {
    if(!_avator) {
        _avator = [[UIImageView alloc] init];
        [self.contentView addSubview:_avator];
    }
    return _avator;
}

- (UIImageView *)senderMessageView {
    if(!_senderMessageView) {
        _senderMessageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_senderMessageView];
    }
    return _senderMessageView;
}

- (UILabel *)messageLabel {
    if(!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = kText_Font;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.senderMessageView addSubview:_messageLabel];
    }
    return _messageLabel;
}


- (void)setFrameModel:(TTCellFrameModel *)frameModel {
    _frameModel = frameModel;
    
    //设置数据
    [self settingData];
    //设置Frame
    [self settingFrame];
}

- (void)settingData {
    
    EMMessage *emMessage = self.frameModel.message;
    //头像
    self.senderAvator.image = [UIImage imageNamed:@"icon_avatar.png"];
    self.senderAvator.layer.cornerRadius = self.senderAvator.frame.size.width/2;
    self.senderAvator.layer.masksToBounds = YES;
    
    //文字
    id body = emMessage.messageBodies[0];
    EMTextMessageBody *textBody = body;
    self.messageLabel.text =  textBody.text;
    
    UIImage *bubbleImage =
    [emMessage.from isEqualToString:kUserName]?
    [UIImage imageNamed:@"SenderTextNodeBkg.png"]:
    [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
    
    CGFloat capWidth =  floorf(bubbleImage.size.width / 2);
    CGFloat capHeight =  floorf(bubbleImage.size.height / 2);
    UIImage *capImage = [bubbleImage resizableImageWithCapInsets:
                         UIEdgeInsetsMake(capHeight, capWidth, capHeight, capWidth)];
    
    //气泡背景
    self.senderMessageView.image = capImage;
}

- (void)settingFrame {
    self.senderAvator.frame = self.frameModel.avatorF;
    self.messageLabel.frame = self.frameModel.messageLabelF;
    self.senderMessageView.frame = self.frameModel.senderMessageViewF;
    
}

@end
