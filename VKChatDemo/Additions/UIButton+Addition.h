//
//  UIButton+Addition.h
//  FFProject
//
//  Created by junming on 9/3/15.
//  Copyright (c) 2015 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (Addition)

// 上下布局按钮
// http://stackoverflow.com/questions/12770751/uibutton-with-title-under-the-imageview
- (void)centerImageAndTitle:(float)spacing;

// 扩大点击响应区域
- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
