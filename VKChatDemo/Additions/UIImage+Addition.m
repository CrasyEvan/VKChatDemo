//
//  UIImage+Addition.m
//  FFProject
//
//  Created by junming on 9/3/15.
//  Copyright (c) 2015 pingan. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

+ (UIImage *)resizableImageNamed:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] resizableImageInCenter];
}

- (UIImage *) resizableImageInCenter
{
    float left = (self.size.width)/2;//The middle points rarely vary anyway
    float top = (self.size.height)/2;
    
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left)];
    }
    else
    {
        return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
}

@end
