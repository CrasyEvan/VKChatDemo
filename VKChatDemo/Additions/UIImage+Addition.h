//
//  UIImage+Addition.h
//  FFProject
//
//  Created by junming on 9/3/15.
//  Copyright (c) 2015 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Addition)

//图片拉伸
+ (UIImage *)resizableImageNamed:(NSString *)imageName;

- (UIImage *)resizableImageInCenter;

@end
