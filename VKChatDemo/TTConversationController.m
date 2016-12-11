
//
//  TTConversationController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTConversationController.h"
#import "EaseMob.h"

@interface TTConversationController ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (nonatomic, strong) EMBuddy *buddy;

@end

@implementation TTConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"聊天";
    // 设置聊天管理器的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    self.buddy = [EMBuddy buddyWithUsername:self.userNameTF.text];
    
}
//- (IBAction)sendMessage:(id)sender {
//
//    /*
//     EMChatText *txtChat = [[EMChatText alloc] initWithText:@"要发送的消息"];
//     EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
//     
//     // 生成message
//     EMMessage *message = [[EMMessage alloc] initWithReceiver:@"6001" bodies:@[body]];
//     message.messageType = eMessageTypeChat;
//     */
//    NSString *text = self.messageTF.text;
//    
//    // 创建一个聊天文本对象
//    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
//    //创建一个文本消息体
//    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
//    //1.构造消息对象
//    EMMessage *msgObj = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[textBody]];
//    msgObj.messageType = eMessageTypeChat;
//    
//    //2.发送消息
//    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj
//                                                  progress:nil
//                                                   prepare:^(EMMessage *message, EMError *error) {
//        NSLog(@"准备发送文字");
//    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
//        NSLog(@"文字发送成功%@",error);
//    } onQueue:nil];
//
//}

#pragma mark 接收好友回复消息
//-(void)didReceiveMessage:(EMMessage *)message{
//    
//    id body = message.messageBodies[0];
//    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本消息
//        EMTextMessageBody *textBody = body;
//        NSString *messageText = textBody.text;
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息来啦！"
//                                                                                 message:messageText
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
//                                                         style:UIAlertActionStyleCancel
//                                                       handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:action];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}

- (IBAction)getConversations:(id)sender {
//    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
//    EMConversation *conseration = [conversations firstObject];
//    NSLog(@"conseration:%d", [conseration loadAllMessages]);
//    NSLog(@"conversations:%lu", (unsigned long)conversations.count);
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"vanke02" conversationType:eConversationTypeChat];
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray *conversation1s = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];

}




@end
