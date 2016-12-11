//
//  UITabbarViewController+Rotation.m
//  baohe
//
//  Created by wu xiaoyue on 12-3-29.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "UITabbarViewController+Rotation.h"

@implementation UITabBarController (Rotation)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    UIViewController *viewController = (UIViewController *)[((UINavigationController *)[self selectedViewController]).viewControllers lastObject];

    if ([viewController respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)]) {
        return [viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    } else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end