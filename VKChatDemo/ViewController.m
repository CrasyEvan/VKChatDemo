//
//  ViewController.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/5.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "ViewController.h"
#import "EaseMob.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)loginPressed:(id)sender {
    
    NSString *username = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }
    
    // 登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:^(NSDictionary *loginInfo, EMError *error) {
        // 登录请求完成后的block回调
        if (!error) {
            /*
             {
             LastLoginTime = 1443083631296;
             jid = "vgios#xmg1chat_xmgtest1@easemob.com";
             password = 123456;
             resource = mobile;
             token = "YWMt-2kmTmKWEeWhivny1t_c6gAAAVEzekiFP9xOO0dqxYGGu4uI5CZNNCoaV0Y";
             username = xmgtest1;
             }
             */
            NSLog(@"登录成功 %@",loginInfo);
            
            // 设置自动登录
            //[[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            // 来主界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
        }else{
            NSLog(@"登录失败 %@",error);
            //User do not exist.
            /** 每一个应用都有自己的注册用户*/
        }
        
    } onQueue:dispatch_get_main_queue()];
}

- (IBAction)registerPressed:(id)sender {
    NSString *username = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    
    if (username.length == 0 || password.length == 0) {
        NSLog(@"请输入账号和密码");
        return;
    }
    
    
    // 注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username
                                                         password:password
                                                   withCompletion:^(NSString *username, NSString *password, EMError *error) {
        NSLog(@"%@",[NSThread currentThread]);
        if (!error) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"注册失败 %@",error);
        }
        
    } onQueue:nil];
    
}




@end
