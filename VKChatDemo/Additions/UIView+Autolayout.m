//
//  UIView+Autolayout.m
//  baiduRouter
//
//  Created by bolei on 14-12-1.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UIView+Autolayout.h"
#import "NSObject+ClassName.h"
#import <objc/runtime.h>

@implementation UIView (Autolayout)

- (NSArray *)addWHConstraintsWithSuperView:(UIView *)superView width:(CGFloat)width height:(CGFloat)height
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSMutableArray *constraintsArray = [NSMutableArray array];
    NSString *key = [NSString stringWithFormat:@"%@%lu",self.className,(unsigned long)self.hash];
    NSDictionary *viewDic = @{key: self};
    NSString *constraintsFormatH = @"";
    if(width != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatH = [NSString stringWithFormat:@"H:[%@(%f)]",key, width];
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatH options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsH];
    }
    
    NSString *constraintsFormatV = @"";
    if(height != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatV = [NSString stringWithFormat:@"V:[%@(%f)]",key,height];
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatV options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsV];
    }
    
    if([constraintsArray count] > 0) {
        [superView addConstraints:constraintsArray];
    }
    
    return constraintsArray;
}

- (NSArray *)addWHConstraintsRelationWithSuperView:(UIView *)superView width:(NSString *)width height:(NSString *)height
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSMutableArray *constraintsArray = [NSMutableArray array];
    NSString *key = [NSString stringWithFormat:@"%@%lu",self.className,(unsigned long)self.hash];
    NSDictionary *viewDic = @{key: self};
    NSString *constraintsFormatH = @"";

    if(![width isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatH = [NSString stringWithFormat:@"H:[%@(%@)]",key,width];
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatH options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsH];
    }
    NSString *constraintsFormatV = @"";
    if(![height isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatV = [NSString stringWithFormat:@"V:[%@(%@)]",key,height];
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatV options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsV];
    }
    
    if([constraintsArray count] > 0) {
        [superView addConstraints:constraintsArray];
    }
    
    return constraintsArray;

}

- (NSArray *)addPaddingConstraintsWithSuperView:(UIView *)superView top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSMutableArray *constraintsArray = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"%@%lu",self.className,(unsigned long)self.hash];
    NSDictionary *viewDic = @{key: self};
    
    NSString *constraintsFormatH = @"";
    //水平
    if(left != CGFLOAT_CONSTRAINTS_INVALID && right != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatH = [NSString stringWithFormat:@"H:|-%f-[%@]-%f-|",left,key,right];
    }else if (left != CGFLOAT_CONSTRAINTS_INVALID) {
        constraintsFormatH = [NSString stringWithFormat:@"H:|-%f-[%@]",left,key];
    }else if (right != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatH = [NSString stringWithFormat:@"H:[%@]-%f-|",key,right];
    }
    
    if([constraintsFormatH length] > 0)  {
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatH options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsH];
    }
    
    NSString *constraintsFormatV = @"";
    //竖直
       if(top != CGFLOAT_CONSTRAINTS_INVALID && bottom != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatV = [NSString stringWithFormat:@"V:|-(%f)-[%@]-(%f)-|",top,key,bottom];
    }else if (top != CGFLOAT_CONSTRAINTS_INVALID) {
        constraintsFormatV = [NSString stringWithFormat:@"V:|-(%f)-[%@]", top,key];
    }else if (bottom != CGFLOAT_CONSTRAINTS_INVALID){
        constraintsFormatV = [NSString stringWithFormat:@"V:[%@]-(%f)-|",key, bottom];
    }
    
    
    if([constraintsFormatV length] > 0)  {
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatV options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsV];
    }
    
    if([constraintsArray count] > 0) {
        [superView addConstraints:constraintsArray];
    }
    
    return constraintsArray;
}
- (NSArray *)addPaddingConstraintsRelationWithSuperView:(UIView *)superView top:(NSString *)top bottom:(NSString *)bottom left:(NSString *)left right:(NSString *)right
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSMutableArray *constraintsArray = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"%@%lu",self.className,(unsigned long)self.hash];
    NSDictionary *viewDic = @{key: self};
    
    NSString *constraintsFormatH = @"";
    //水平
    if(![left isEqualToString:NSSTRING_CONSTRAINTS_INVALID] && ![right isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatH = [NSString stringWithFormat:@"H:|-(%@)-[%@]-(%@)-|",left,key,right];
    }else if (![left isEqualToString:NSSTRING_CONSTRAINTS_INVALID]) {
        constraintsFormatH = [NSString stringWithFormat:@"H:|-(%@)-[%@]",left,key];
    }else if (![right isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatH = [NSString stringWithFormat:@"H:[%@]-(%@)-|",key,right];
    }
    
    if([constraintsFormatH length] > 0)  {
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatH options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsH];
    }
    
    NSString *constraintsFormatV = @"";
    //竖直
    if(![top isEqualToString:NSSTRING_CONSTRAINTS_INVALID]  && ![bottom isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatV = [NSString stringWithFormat:@"V:|-(%@)-[%@]-(%@)-|",top,key, bottom];
    }else if (![top isEqualToString:NSSTRING_CONSTRAINTS_INVALID] ) {
        constraintsFormatV = [NSString stringWithFormat:@"V:|-(%@)-[%@]", top,key];
    }else if (![bottom isEqualToString:NSSTRING_CONSTRAINTS_INVALID]){
        constraintsFormatV = [NSString stringWithFormat:@"V:[%@]-(%@)-|",key, bottom];
    }
    
    
    if([constraintsFormatV length] > 0)  {
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatV options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsV];
    }
    
    if([constraintsArray count] > 0) {
        [superView addConstraints:constraintsArray];
    }
    
    return constraintsArray;

}
- (NSArray *)addPaddingConstraintsWithNextView:(UIView *)nextView superView:(UIView *)superView verticalPadding:(NSString *)verticalPadding horizontalPadding:(NSString *)horizontalPadding
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSMutableArray *constraintsArray = [NSMutableArray array];
    
    NSString *keySelf = [NSString stringWithFormat:@"%@%lu",self.className,(unsigned long)self.hash];
    NSString *keyNext = [NSString stringWithFormat:@"%@%lu",nextView.className,(unsigned long)nextView.hash];
    
    NSDictionary *viewDic = @{keySelf: self,keyNext:nextView};
    NSString *constraintsFormatH = @"";
    if (![horizontalPadding isEqual:NSSTRING_CONSTRAINTS_INVALID]) {
        constraintsFormatH = [NSString stringWithFormat:@"H:|-[%@]-(%@)-[%@]",keySelf, horizontalPadding, keyNext];
    }
    NSString *constraintsFormatV = @"";
    if (![verticalPadding isEqual:NSSTRING_CONSTRAINTS_INVALID]) {
        constraintsFormatV = [NSString stringWithFormat:@"V:|-[%@]-(%@)-[%@]",keySelf,verticalPadding,keyNext];
    }
    
    if([constraintsFormatH length] > 0)  {
        NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatH options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsH];
    }
    if([constraintsFormatV length] > 0)  {
        NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:constraintsFormatV options:0 metrics:nil views:viewDic];
        [constraintsArray addObjectsFromArray:constraintsV];
    }
    
    if([constraintsArray count] > 0) {
        [superView addConstraints:constraintsArray];
    }
    
    return constraintsArray;
    
}

//设置Autolayout中的边距辅助方法
- (NSLayoutConstraint *)setEdge:(UIView*)superview attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:1.0 constant:constant];
    [superview addConstraint:constraint];
    return constraint;
}


@end
