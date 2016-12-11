//
//  UIView+Helpers.m
//  netdisk_iPhone
//
//  Created by tom on 7/16/13.
//  Copyright (c) 2013 baidu. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIView+Helpers.h"

@implementation UIView (Helpers)

- (UIView *)firstSuperViewMatchingClass:(Class)aClass
{
    UIView *superView = self.superview;
    while (superView != nil) {
        if ([superView isKindOfClass:aClass]) {
            return superView;
        } else {
            superView = superView.superview;
        }
    }
    return nil;
}

- (void)shakeStatus:(BOOL)enabled
{
    if (enabled) {
        CGFloat rotation = 0.03;

        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
        shake.duration = 0.13;
        shake.autoreverses = YES;
        shake.repeatCount = MAXFLOAT;
        shake.removedOnCompletion = NO;
        shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -rotation, 0.0, 0.0, 1.0)];
        shake.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0, 0.0, 1.0)];

        [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    } else {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
