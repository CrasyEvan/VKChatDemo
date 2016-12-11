//
//  UIView+Autolayout.h
//  baiduRouter
//
//  Created by bolei on 14-12-1.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CGFLOAT_CONSTRAINTS_INVALID    CGFLOAT_MIN    //传此值表示不设置此约束
#define NSSTRING_CONSTRAINTS_INVALID    @"invalid" //传此值表示不设置此约束

@interface UIView (Autolayout)
/**
 *	@brief	添加上下左右相对于superview的约束，不适用于相对于其他子view的位置,参数大小为CGFLOAT_CONSTRAINTS_INVALID表示不设置（
 *
 *	@param 	superView 	所处的superView
 *	@param 	top 	距 //
 *	@param 	bottom 	距下
 *	@param 	left 	距左
 *	@param 	right 	距右
 *
 *	@return	添加需要的约束并返回添加的约束
 */
- (NSArray *)addPaddingConstraintsWithSuperView:(UIView *)superView top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right ;

// 描述边距的关系 ，大于等于
- (NSArray *)addPaddingConstraintsRelationWithSuperView:(UIView *)superView top:(NSString *)top bottom:(NSString *)bottom left:(NSString *)left right:(NSString *)right ;
// 描述两个是同一层级关系的view之间的约束关系
- (NSArray *)addPaddingConstraintsWithNextView:(UIView *)nextView superView:(UIView *)superView verticalPadding:(NSString *)verticalPadding horizontalPadding:(NSString *)horizontalPadding;

/**
 *	@brief	添加宽高相对于superView的约束，参数大小为CGFLOAT_CONSTRAINTS_INVALID表示不设置
 *
 *	@param 	superView 	所处的superView
 *	@param 	width 	宽度
 *	@param 	height 	高度
 *
 *	@return	添加需要的约束并返回添加的约束
 */
- (NSArray *)addWHConstraintsWithSuperView:(UIView *)superView width:(CGFloat)width height:(CGFloat)height;
// 描述宽高的关系
- (NSArray *)addWHConstraintsRelationWithSuperView:(UIView *)superView width:(NSString *)width height:(NSString *)height;


/**
 *	@brief	设置边距的一些方法，也可以用于设置居中等
 *
 *	@param 	superview 	所处的superView
 *	@param 	attr 	NSLayoutAttribute
 *	@param 	constant 	具体值
 *
 *	@return	添加需要的约束并返回添加的约束
 */
- (NSLayoutConstraint *)setEdge:(UIView*)superview attr:(NSLayoutAttribute)attr constant:(CGFloat)constant;


@end
