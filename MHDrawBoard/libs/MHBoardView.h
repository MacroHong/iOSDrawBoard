//
//  MHBoardView.h
//  MHDrawBoard
//
//  Created by Macro on 11/4/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHBoardView : UIView

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  设置画笔颜色,默认黑色
 *
 *  @param color 画笔颜色
 */
- (void)setLineColor:(UIColor *)color;

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  设置画笔宽度,默认为3
 *
 *  @param width 画笔宽度
 */
- (void)setLineWidth:(CGFloat)width;

/*!
 *  @author Macro QQ:778165728, 16-09-01
 *
 *  @brief  设置画板背景图
 *
 *  @param image 背景图
 */
- (void)setBackgroundImage:(UIImage *)image;

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  清屏
 */
- (void)clear;

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  回退
 */
- (void)back;

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  获取画板的图片
 *
 *  @return image
 */
- (UIImage *)getImage;

@end
