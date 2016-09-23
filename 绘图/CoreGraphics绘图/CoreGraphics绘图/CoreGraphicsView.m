//
//  CoreGraphicsView.m
//  CoreGraphics绘图
//
//  Created by tens04 on 16/9/1.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "CoreGraphicsView.h"

@implementation CoreGraphicsView


- (void)drawRect:(CGRect)rect {
    
    // [self drawLines];
    
    [self drawGraphics];
    [self drawText];
    [self drawImage];
}


- (void)drawLines {
    
    // 1、获取当前绘图上下文(绘图环境)、可以理解为创建一块画布
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    // 2、移动到某个点
    CGContextMoveToPoint(cxt, 20, 100);
    
    // 3、添加一条直线到某个点
    CGContextAddLineToPoint(cxt, 300, 100);
    CGContextAddLineToPoint(cxt, 160, 300);
    
    // 闭合路径
    CGContextClosePath(cxt);
    
    // 4、设置描边和填充颜色
    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    //CGContextSetRGBStrokeColor(cxt, 200/255.0, 300/255.0, 10/255.0, 1);
    // CGContextSetCMYKStrokeColor(cxt, 0.1, 0.3, 0.5, 0.8, 1);
    CGContextSetFillColorWithColor(cxt, [UIColor whiteColor].CGColor);
    
    // 5、设置线条宽度
    CGContextSetLineWidth(cxt, 5);
    
    // 6、设置线头样式
    CGContextSetLineCap(cxt, kCGLineCapRound);
    
    // 7、设置线条连接点的样式
    CGContextSetLineJoin(cxt, kCGLineJoinRound);
    
    // 8、设置虚线
    // CGFloat lengths[] = {2,10,2};
    // CGContextSetLineDash(cxt, 0, lengths, 3);
    
    // 9、是否开启抗锯齿
    CGContextSetShouldAntialias(cxt, YES);
    
    
    // 10、绘制描边
    // CGContextStrokePath(cxt);
    // 11、绘制填充
    // CGContextFillPath(cxt);
    
    // 12、绘制描边、填充、描边和填充、奇偶填充：kCGPathFill,kCGPathEOFill,kCGPathStroke,kCGPathFillStroke, kCGPathEOFillStroke
    CGContextDrawPath(cxt, kCGPathFillStroke);
    
}

#pragma 画图形
- (void)drawGraphics {
    
    CGContextRef cxt =  UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    CGContextSetLineWidth(cxt, 5);
    
    // 1、绘制矩形
    CGContextAddRect(cxt, CGRectMake(20, 100, 320, 150));
    CGContextDrawPath(cxt, kCGPathStroke);
    
    // 保存上下文状态（入栈）
    CGContextSaveGState(cxt);
    
    // 2、绘制内切椭圆、圆
    CGContextAddEllipseInRect(cxt, CGRectMake(20, 260, 320, 150));
    CGContextSetStrokeColorWithColor(cxt, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(cxt, 10);
    CGContextDrawPath(cxt, kCGPathStroke);
    
    // 恢复上下文状态（出栈）
    CGContextRestoreGState(cxt);
    
    
    // 3、绘制圆弧
    CGContextMoveToPoint(cxt, 250, 500);
    CGContextAddArc(cxt, 250, 500, 50, 0, M_PI_2, NO);
    
    // 4、绘制贝塞尔曲线
    // cpx、cpy: 控制点的坐标， x、y目标点的坐标
    // CGContextAddQuadCurveToPoint(cxt, <#CGFloat cpx#>, <#CGFloat cpy#>, <#CGFloat x#>, <#CGFloat y#>)
    
    // CGContextAddCurveToPoint(<#CGContextRef  _Nullable c#>, <#CGFloat cp1x#>, <#CGFloat cp1y#>, <#CGFloat cp2x#>, <#CGFloat cp2y#>, <#CGFloat x#>, <#CGFloat y#>)
    
    CGContextDrawPath(cxt, kCGPathStroke);
    
}


- (void)drawText {
    
    NSString *text = @"绘制的文字";
    
    CGRect rect = CGRectMake(20, 30, 200, 20);
    [text drawInRect:rect withAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],
                                           NSBackgroundColorAttributeName:[UIColor whiteColor],
                                           NSFontAttributeName : [UIFont systemFontOfSize:20]}];
}


- (void)drawImage {
    
    // CGContextRef cxt =  UIGraphicsGetCurrentContext();
    
    UIImage *image = [UIImage imageNamed:@"photo.jpg"];
    
    CGRect rect = CGRectMake(20, 100, 320, 150);
    [image drawInRect:rect];
    
    //
    // CGContextDrawImage(cxt, rect, image.CGImage);
}

@end
