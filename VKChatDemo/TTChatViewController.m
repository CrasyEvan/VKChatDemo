//
//  TTChatViewController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTChatViewController.h"
#import "EaseMob.h"

#import "TTChatCell.h"

#import "TTInputToolBarView.h"
#import "TTCellFrameModel.h"
#import "TTTimeCell.h"
#import "TTTimeTool.h"

#import "NSDate+Category.h"
#import "NSDate+Helper.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height


@interface TTChatViewController ()<EMChatManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>


/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) UITableView *tableView;

/** 当前添加的时间 */
@property (nonatomic, copy) NSString *lastTimeStr;

/** 当前会话对象 */
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, strong) TTInputToolBarView *inputBarView;
@property (nonatomic, strong) EMBuddy *buddy;
@property (nonatomic, assign) CGRect keyboardFrame;

@end

@implementation TTChatViewController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.userID;
    //加载聊天记录
    [self loadLocalChatRecords];
    [self initTableView];
    [self initInputToolBar];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self scrollToBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputBarView.textView endEditing:YES];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-46) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(releaseKeyBoard)];
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)initInputToolBar {
    
    self.inputBarView = [[TTInputToolBarView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, kScreen_Width, 46)];
    [self.inputBarView.senderButton addTarget:self action:@selector(senderButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inputBarView];
    self.inputBarView.textView.delegate = self;

}

#pragma mark -发送消息
- (void)senderButtonPressed {

    //拿到user Id
    NSLog(@"userID:%@", self.userID);
    self.buddy = [EMBuddy buddyWithUsername:self.userID];
    
    NSString *message = self.inputBarView.textView.text;
    if(!message.length) {
        NSLog(@"请输入聊天内容");
        return;
    }
    
    // 创建一个聊天文本对象
    EMChatText *chatText = [[EMChatText alloc] initWithText:message];
    
    //创建一个文本消息体
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    //1.构造消息对象
    EMMessage *msgObj = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[textBody]];
    msgObj.messageType = eMessageTypeChat;
    
    //2.发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj progress:nil
                                                   prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送文字");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"文字发送成功%@",error);
        self.inputBarView.textView.text = @"";

    } onQueue:nil];
    
    [self addDataSourcesWithMessage:msgObj];
    
    [self.tableView reloadData];
    [self scrollToBottom];
}

#pragma mark 接收回复消息
-(void)didReceiveMessage:(EMMessage *)message{
    
    self.buddy = [EMBuddy buddyWithUsername:message.from];
    id body = message.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        NSString *messageText = textBody.text;
        NSLog(@"receive message:%@", messageText);
    }
    
    if ([message.from isEqualToString:self.buddy.username]){
        [self addDataSourcesWithMessage:message];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //1.先获取消息模型
    //EMMessage *message = self.dataSources[indexPath.row];
    
    //显示时间cell
    static NSString *timeCellID = @"timeCellID";
    if ([self.dataSources[indexPath.row] isKindOfClass:[NSString class]]) {
        TTTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:timeCellID];
        if(timeCell == nil) {
            timeCell = [[TTTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeCellID];
        }
        timeCell.timeLabel.text = [self.dataSources objectAtIndex:indexPath.row];
        return timeCell;
    }else {
        //聊天消息
        static NSString *senderChatCellID = @"chatCellID";
        TTChatCell  *chatCell = nil;
        chatCell = [tableView dequeueReusableCellWithIdentifier:senderChatCellID];
        if(chatCell == nil) {
            chatCell = [[TTChatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:senderChatCellID];
        }
        TTCellFrameModel *cellFrameModel = [self.dataSources objectAtIndex:indexPath.row];
        chatCell.frameModel = cellFrameModel;
        return chatCell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSources[indexPath.row] isKindOfClass:[NSString class]]) {
        return 44;
    }else {
        TTCellFrameModel *cellFrameModel = [self.dataSources objectAtIndex:indexPath.row];
        return cellFrameModel.cellHeight;
    }
}

-(void)loadLocalChatRecords {
    // 假设在数组的第一位置添加时间
    //[self.dataSources addObject:@"16:06"];
    NSLog(@"userID:%@", self.userID);
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager
                                    conversationForChatter:self.userID conversationType:eConversationTypeChat];
    self.conversation = conversation;
    NSArray *messages = [conversation loadAllMessages];
    for (EMMessage *msgObj in messages) {
        [self addDataSourcesWithMessage:msgObj];
    }
    NSLog(@"消息数目:%lu", (unsigned long)self.dataSources.count);
}

-(void)addDataSourcesWithMessage:(EMMessage *)msg{

    if(self.lastTimeStr) {
        
        NSDate *currentDate = [NSDate dateFromLongLong:msg.timestamp];
        NSString *currentTimeStr = [NSDate stringFromDate:currentDate];
        
        BOOL isShowTimeCell = [TTTimeTool isShowMsgTime:_lastTimeStr endTime:currentTimeStr];
        if(isShowTimeCell) {
            NSString *timeStr = [TTTimeTool timeStr:msg.timestamp];
            [self.dataSources addObject:timeStr];
        }
        
        //更新最近一条信息的时间戳
        self.lastTimeStr = currentTimeStr;
        NSLog(@"isShowTimeCellL:%d", isShowTimeCell);
    }else {
        
        NSDate *lastDate = [NSDate dateFromLongLong:msg.timestamp];
        self.lastTimeStr = [NSDate stringFromDate:lastDate];
    }
   
    // 2.再加EMMessage
    [self.dataSources addObject:[TTCellFrameModel addFrameModelwithTargetMessage:msg]];
    // 3.设置消息为已读取
    [self.conversation markMessageWithId:msg.messageId asRead:YES];
    
}


#pragma mark - keyBoard Nofitation
-(void)keyBoardWillShow:(NSNotification *)noti{
    
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrm.size.height;
    self.keyboardFrame = kbEndFrm;
//    CGRect rect = self.inputBarView.frame;
//    rect.origin.y -= kbHeight;
//    self.inputBarView.frame = rect;
//    
//    CGRect tableViewF = self.tableView.frame;
//    tableViewF.origin.y -= kbHeight;
//    self.tableView.frame = tableViewF;
//    
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}
#pragma mark 键盘退出时会触发的方法
-(void)keyBoardWillHide:(NSNotification *)noti{
    
    CGRect tableViewF = self.tableView.frame;
    tableViewF.origin.y = 0;
    self.tableView.frame = tableViewF;
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = self.inputBarView.frame;
        rect.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height;
        self.inputBarView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - SrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputBarView.textView resignFirstResponder];
}

-(void)scrollToBottom{
    
    //1.获取最后一行
    if (self.dataSources.count == 0) {
        return;
    }
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.dataSources.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });

}

- (void)releaseKeyBoard {
    [self.inputBarView.textView endEditing:YES];
}

#pragma mark - UITextfield Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.4 animations:^{
        CGRect tableViewF = self.tableView.frame;
        tableViewF.origin.y -= _keyboardFrame.size.height;
        self.tableView.frame = tableViewF;
        
        CGRect rect = self.inputBarView.frame;
        rect.origin.y -= _keyboardFrame.size.height;
        self.inputBarView.frame = rect;
        [self scrollToBottom];
    } completion:^(BOOL finished) {
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
