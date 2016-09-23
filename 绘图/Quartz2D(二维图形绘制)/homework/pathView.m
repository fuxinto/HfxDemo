//
//  pathView.m
//  homework
//
//  Created by tens04 on 16/8/29.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "pathView.h"

@implementation pathView


- (void)drawRect:(CGRect)rect {
 //   [self drawPathOne];
    [self drawPathTwo];
}

- (void)drawPathOne {
    
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:2];
    [path moveToPoint:CGPointMake(0, height/2)];
    for (int i = 1; i < 8; i++) {
        int a = arc4random()%50;
        
        CGPoint point = CGPointMake(50 * i, (height/2)-a);
        [path addLineToPoint:point];
        
    }
    [[UIColor orangeColor] setStroke];
    [path stroke];
}

#pragma mark - 绘制正弦
- (void)drawPathTwo {
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, height/2)];
    [path addLineToPoint:CGPointMake(width, height/2)];
    
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width/2, height)];
    
    [[UIColor whiteColor] setStroke];
    
    
    [path moveToPoint:CGPointMake(0, height/2)];
    
    CGFloat wid = width / 8;
    for (int i = 0; i < 10; i++) {
        
        // 控制点的Y坐标
        CGFloat controlPoint_Y = 0;
        if (i % 2 == 0) {
            
            controlPoint_Y = height / 2 + 100;
        } else {
            
            controlPoint_Y = height / 2 - 100;
        }
        
        CGPoint beginPoint = CGPointMake(i * wid, height / 2);
        CGPoint endPoint = CGPointMake(beginPoint.x + wid, height / 2);
        CGPoint controlPoint = CGPointMake((wid / 2)+ (i * wid), controlPoint_Y);
        
        [path moveToPoint:beginPoint];
        [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    }
    [path stroke];
    
}



@end
