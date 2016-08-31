//
//  MHBoardView.m
//  MHDrawBoard
//
//  Created by Macro on 11/4/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "MHBoardView.h"

@interface MHBoardView ()
{
    // 记录画板上的每一路径(每一路径又是一个小数组(小数组中的元素是点))
    NSMutableArray *_totalPathPoints;
    UIColor *_lineColor; // 画笔颜色
    CGFloat _lineWidth; // 画笔宽度
    UIImage *_bgImage; // 画板背景图
}
@end

@implementation MHBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认值
        self.backgroundColor = [UIColor whiteColor];
        _totalPathPoints = [[NSMutableArray alloc] init];
        _lineColor = [UIColor blackColor];
        _lineWidth = 3;
    }
    return self;
}


/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  清屏
 */
- (void)clear {
    [_totalPathPoints removeAllObjects];
    [self setNeedsDisplay];
}

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  回退
 */
- (void)back {
    // 移除上一路径
    [_totalPathPoints removeLastObject];
    [self setNeedsDisplay];
}

// 确定每一路径的起点 每一路径的开始都出发此方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 每一路径的起点
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:touch.view];
    
    // 为这一路径创建数组保存起点
    NSMutableArray *pathPoints = [[NSMutableArray alloc] init];
    [pathPoints addObject:[NSValue valueWithCGPoint:startPoint]];
    
    // 添加这一路径的所有点到大数组中(当前只有起点一个点)
    [_totalPathPoints addObject:pathPoints];
    
    [self setNeedsDisplay];
}

// 每一路径的拖动触发此方法
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:touch.view];
    
    // 获取当前这一路径的数组
    NSMutableArray *pathPoints = [_totalPathPoints lastObject];
    [pathPoints addObject:[NSValue valueWithCGPoint:movePoint]];
    
    [self setNeedsDisplay];
}

// 最后一个点
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 把最后一个加到当前路径的数组中
    [self touchesMoved:touches withEvent:event];
}

// 绘制 每产生一个新的点 就触发此方法
- (void)drawRect:(CGRect)rect {
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景图片
    if (_bgImage) {
        CGImageRef image = CGImageRetain(_bgImage.CGImage);
        MHDrawImage(context, [self fixBgImageFrame], image);
        CGImageRelease(image);
    }
    
    for (NSMutableArray *pathPoints in _totalPathPoints) {
         // 一条路径
        for (int i = 0; i<pathPoints.count; i++) {
            CGPoint pos = [pathPoints[i] CGPointValue];
            if (i == 0) {
                // 设置新的路径
                CGContextMoveToPoint(context, pos.x, pos.y);
            } else {
                // 连到对应的路径上
                CGContextAddLineToPoint(context, pos.x, pos.y);
            }
        }
    }
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextStrokePath(context);
}

// 坐标转换
void MHDrawImage(CGContextRef context, CGRect rect, CGImageRef image) {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
}

// 让背景图片等比例居中
- (CGRect)fixBgImageFrame {
    CGFloat w1 = self.frame.size.width;
    CGFloat h1 = self.frame.size.height;
    CGFloat w2 = _bgImage.size.width;
    CGFloat h2 = _bgImage.size.height;
    
    CGFloat x=0;
    CGFloat y=0;
    CGFloat width=0;
    CGFloat height=0;
    
    if (w2*h1>=w1*h2) {
        if (w2>=w1) {
            x=0;
            width=w1;
            height=width*h2/w2;
            y = (h1-height)/2;
        } else {
            width=w2;
            height=h2;
            x=(w1-width)/2;
            y=(h1-height)/2;
        }
    } else {
        if (h2>=h1) {
            y=0;
            height=h1;
            width=w2*height/h2;
            x=(w1-width)/2;
        } else {
            width=w2;
            height=h2;
            x=(w1-width)/2;
            y=(h1-height)/2;
        }
    }
    return CGRectMake(x, y, width, height);
}

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  获取画板的图片
 *
 *  @return image
 */
- (UIImage *)getImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, self.layer.contentsScale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  设置画笔颜色
 *
 *  @param color 画笔颜色
 */
- (void)setLineColor:(UIColor *)color {
    _lineColor = color;
}

/*!
 *  @author Macro QQ:778165728, 16-09-01
 *
 *  @brief  设置画板背景图
 *
 *  @param image 背景图
 */
- (void)setBackgroundImage:(UIImage *)image {
    _bgImage = image;
}

/*!
 *  @author Macro QQ:778165728, 15-11-04
 *
 *  @brief  设置画笔宽度
 *
 *  @param width 画笔宽度
 */
- (void)setLineWidth:(CGFloat)width {
    _lineWidth = width;
}


@end
