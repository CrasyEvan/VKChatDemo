
//
//  TTContactViewController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TTContactViewController.h"
#import "TTChatViewController.h"

#import "EaseMob.h"


@interface TTContactViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *conversations;

@end

@implementation TTContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self loadConversations];

    [self initTableView];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)loadConversations{
    //获取历史会话记录
    //1.从内存获取历史会话记录
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    //2.如果内存里没有会话记录，从数据库Conversation表
    if (conversations.count == 0) {
        conversations =  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
    
    NSLog(@"zzzzzzz %@",conversations);
    self.conversations = conversations;
    
}


#pragma mark - UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    EMConversation *conversation = _conversations[indexPath.row];
    
    NSString *chatter = conversation.chatter;
    NSArray *array = [conversation loadAllMessages];
    EMMessage *message = [conversation latestMessage];
    long long timerStamp = [message timestamp];
    cell.textLabel.text =  conversation.chatter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMConversation *conversation = _conversations[indexPath.row];
    NSString *chatter = conversation.chatter;

    TTChatViewController *charViewController = [[TTChatViewController alloc] init];
    charViewController.hidesBottomBarWhenPushed = YES;
    charViewController.userID = chatter;
    [self.navigationController pushViewController:charViewController animated:YES];
}


@end
