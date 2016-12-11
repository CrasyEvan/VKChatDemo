//
//  UINavigationController+Autorotate.m
//  netdisk_iPhone
//
//  Created by lingaohe on 9/27/12.
//  Copyright (c) 2012 baidu. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)
- (BOOL)shouldAutorotate
{
#if 0
  BOOL rotatable = [self.visibleViewController shouldAutorotate];
  DDLogInfo(@"UINavigationController:%@,Rotatable:%d",NSStringFromSelector(_cmd), rotatable);
  //对iOS6的音视频播放进行特殊处理，这个实现方式比较挫，暂时没有更好的方法
  if ([self.visibleViewController isKindOfClass:[BDMoviePlayerViewController class]]) {
    rotatable = NO;
  }
  return rotatable;
#else
    return [[self.viewControllers lastObject] shouldAutorotate];
#endif
}

- (NSUInteger)supportedInterfaceOrientations
{
    //  return [self.visibleViewController supportedInterfaceOrientations];
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation result = [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    if (result) {
        return result;
    } else {
        //如果子视图没有设置这个方法，就返回支持除倒转之外的方向
        return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
  }
}
@end
