//
//  UITabBarController+Autorotate.m
//  netdisk_iPhone
//
//  Created by lingaohe on 9/27/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "UITabBarController+Autorotate.h"

@implementation UITabBarController (Autorotate)
- (BOOL)shouldAutorotate
{
    BOOL rotatable = [self.selectedViewController shouldAutorotate];
    return rotatable;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
@end
