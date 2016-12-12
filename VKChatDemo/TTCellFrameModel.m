


//
//  TTReceiveCellViewModel.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/11.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTCellFrameModel.h"

#define kText_Font [UIFont systemFontOfSize:14]
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kUserName @"vanke03"

@implementation TTCellFrameModel


- (void)setMessage:(EMMessage *)message {
    _message = message;
    id body = message.messageBodies[0];
    EMTextMessageBody *textBody = body;
    BOOL isSender = [_message.from isEqualToString:kUserName];
    
    //头像
    if(isSender) {
        //发送者
        _avatorF = CGRectMake(kScreen_Width-5-44, 5, 44, 44);
    }else {
        //接收者
        _avatorF = CGRectMake(5, 5, 44, 44);
    }
    
    //气泡
    UIImage *bubbleImage = [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
    _bubbleImageSize = bubbleImage.size;
    
    //文字
    NSDictionary *attributes = @{NSFontAttributeName:kText_Font};
    CGSize contentSize=[textBody.text boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    

    //气泡背景
    CGRect rect = _senderMessageViewF;
    CGFloat cellHeight = 0;  //默认高度
    CGFloat cellWidth = 80;  //默认宽度
    _messageLabelF = CGRectMake(10, 5, contentSize.width+4, contentSize.height+4);
    
    //文字高度不够调整origin.y
//    if(contentSize.height+4 < _bubbleImageSize.height) {
//        
//        _messageLabelF = CGRectMake(10, 10, contentSize.width+4, contentSize.height+4);
//    }
    
    //文字宽度不够调整origin.x
    if(contentSize.width+4 < cellWidth){

        CGFloat originX_offset = (cellWidth - contentSize.width+4)/2;
        if(isSender) {
            _messageLabelF = CGRectMake(originX_offset, 10, contentSize.width+4, contentSize.height+4);
        }else {
            _messageLabelF = CGRectMake(originX_offset + 5, 10, contentSize.width+4, contentSize.height+4);
        }
    }
    
    //
    if(_messageLabelF.size.height < _bubbleImageSize.height) {
        cellHeight = _bubbleImageSize.height;
    } else {
        cellHeight = _messageLabelF.size.height + 10*2;
    }

    rect.size.height = cellHeight;
    
    //文字宽度比图片默认宽度小
    if(contentSize.width < cellWidth) {
        cellWidth += 15;
    }else {
        cellWidth = contentSize.width + 25;
    }
    
    rect.size.width = cellWidth;
    if([message.from isEqualToString:kUserName]) {
        //发送者
        rect.origin.x = kScreen_Width - cellWidth - 5*2 - 44;
    }else {
        //接收者
        rect.origin.x = 5 + 44 + 5;
    }
    rect.origin.y += 2;
    
    _senderMessageViewF = rect;
    //
    if(self.avatorF.size.height > self.messageLabelF.size.height) {
        _cellHeight =  5  + self.avatorF.size.height + 10 + 5;
    }else {
        _cellHeight =  5  + self.messageLabelF.size.height + 10 + 5;
    }
    
    
}

+ (NSMutableArray *)initWithMessage:(NSMutableArray *)emMessage {
    // 遍历数据源
    NSMutableArray *arrayM = [NSMutableArray array];

    for(int i = 0; i<emMessage.count; i++) {
        
        //要添加的FrameModel对象
        TTCellFrameModel *cellFrameModel = [[TTCellFrameModel alloc] init];

        //调用本身set方法
        EMMessage *message = [emMessage objectAtIndex:i];
        if([message isKindOfClass:[EMMessage class]]) {
            cellFrameModel.message = message;
            [arrayM addObject:cellFrameModel];
        }else {
            [arrayM addObject:[TTCellFrameModel new]];
        }
    }
    return arrayM;
}

+ (TTCellFrameModel *)addFrameModelwithTargetMessage:(EMMessage *)targetMessage{
    TTCellFrameModel *cellFrameModel = [[TTCellFrameModel alloc] init];
    EMMessage *message = targetMessage;
    cellFrameModel.message = message;
    return cellFrameModel;
}

@end
