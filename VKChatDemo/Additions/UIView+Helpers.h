//
//  UIView+Helpers.h
//  netdisk_iPhone
//
//  Created by tom on 7/16/13.
//  Copyright (c) 2013 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helpers)
- (UIView *)firstSuperViewMatchingClass:(Class)aClass;
- (void)shakeStatus:(BOOL)enabled;
- (UIViewController *)viewController;
@end
