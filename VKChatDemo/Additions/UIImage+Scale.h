//
//  UIImage+Scale.h
//  baiduRouter
//
//  Created by mco-device on 14-1-14.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义了在缩放图片时，以哪条边作为参考边
typedef enum {
    EQDUIImageZommLineDefault, // 默认值
    EQDUIImageZommLineWidth, // 宽作为参考边
    EQDUIImageZommLineHeight, // 高作为参考边
    EQDUIImageZommLineLonger, // 长边作为参考边
    EQDUIImageZommLineShorter, // 短边作为参考边
    EQDUIImageZommLineNone, // 不区分边
} BRUIImageZommLine;

@interface UIImage (Scale)

// 缩放图片
+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//截取部分图像
+ (UIImage *)getSubImage:(UIImage *)img rect:(CGRect)rect;
//中间拉伸自动宽高
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;
+ (UIImage *)middleStretchableImage:(UIImage *)image;
+ (UIImage *)strechImage:(UIImage *)image left:(CGFloat)left top:(CGFloat)top;
//中间拉伸图片,不支持换肤
+ (UIImage *)middleStretchableImageWithOutSupportSkin:(NSString *)key;

+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size cornerRadius:(CGFloat)radius;

// 缩放图片并且剧中截取
+ (UIImage *)middleScaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//宽高取小缩放，取大居中截取
+ (UIImage *)suitableScaleImage:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *	@brief	最短边等比压缩或拉伸至给定边长后：较高的图则截取上部分，较宽的图则截取中间部分
 *
 *	@param 	originalImage 	The source image instance
 *	@param 	size 	          The final size
 *
 *	@return
 */
+ (UIImage *)suitableScaleImageAndCropIfNeeded:(UIImage *)originalImage withSize:(CGSize)size;
//等比缩放到多少倍
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
//等比例缩放
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
// zhengzheng
//等比缩放
+ (UIImage *)scaleImageForImage:(UIImage *)image toScale:(float)scaleSize;
- (UIImage *)fixOrientation;

//截取部分图像(区分高分屏或者低分屏)
/* ++++++++++++++++++++++++++++++++++++++
 *
 * zhengzheng

 @param img 需要被截取的图片
 @param scale  倍率（低分屏1.0 高分屏2.0）
 @param rect 截取的范围
 @return 返回截取后的图片
 */
+ (UIImage *)getSubImage:(UIImage *)img scale:(CGFloat)scale rect:(CGRect)rect;
/* ------------------------------------- */
+ (UIImage *)zoomListImageWithImage:(UIImage *)image;
+ (UIImage *)zoomUploadImageWith:(UIImage *)image rate:(CGFloat)rate maxLength:(CGFloat)length quality:(CGFloat)quality limitSize:(long long)spaceSize;
+ (UIImage *)zoomThumbnailWith:(UIImage *)image rate:(CGFloat)rate maxLength:(CGFloat)length;
+ (long long)check:(UIImage *)image;

+ (UIImage *)zoomUploadImageWith:(UIImage *)image rate:(CGFloat)rate maxLength:(CGFloat)length;

/**
 *	@brief	fix image orientation.This method used in take photo
 *
 *	@param 	aImage: 	the image that want to fix
 *  @param  orient:     the orient want to fix
 *
 *	@return	return fix image
 */
- (UIImage *)fixOrientation:(UIImageOrientation) orient;
/**
 *	@brief	check if the current image size is match the given size
 *
 *	@param 	size 	the given size
 *
 *	@return	YES OR NO
 */
- (BOOL)isMatchSize:(CGSize)size;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
