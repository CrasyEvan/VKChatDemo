//
//  AppDelegate.m
//  VKChatDemo
//
//  Created by Evan on 2016/12/5.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    //    [[EaseMob sharedInstance] registerSDKWithAppKey:@"vgios#xmg1chat" apnsCertName:nil];
    // 1.初始化SDK，并隐藏环信SDK的日志输入
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"1107161128178347#vankechatdemo" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger:@(YES)}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 2.监听自动登录的状态
    // 设置chatManager代理
    // 写个nil 默认代理会在主线程调用
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    // 3.如果登录过，直接来到主界面
//    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
//        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
//    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];

}


@end
