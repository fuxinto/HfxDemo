//
//  ViewController.m
//  CAKeyframeAnimation---UIBezierPath
//
//  Created by tens04 on 16/8/26.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
@interface ViewController () {
    
    CALayer *aniLayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = self.view.bounds;
    bgLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:bgLayer];
    bgLayer.delegate = self;
    
    // 重绘
    [bgLayer setNeedsDisplay];
    
    
    aniLayer = [CALayer layer];
    aniLayer.bounds = CGRectMake(0 , 0, 100, 100);
    aniLayer.position = CGPointMake(Width / 2, 50);
    aniLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"足球"].CGImage);
    [self.view.layer addSublayer:aniLayer];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [aniLayer addAnimation:[self keyframeAnimation] forKey:@"keyAnimation"];
}


- (CAAnimation *)keyframeAnimation {
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 4;
    //    keyAnimation.autoreverses = YES;
    keyAnimation.repeatCount = HUGE_VALF;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.removedOnCompletion = NO;
    
    
        keyAnimation.calculationMode = kCAAnimationLinear;
    
    
    keyAnimation.path = [self path].CGPath;
    
    return keyAnimation;
    
}

// 绘图
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    CGContextAddPath(ctx , [self path].CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 5);
    CGContextDrawPath(ctx, kCGPathStroke);
}

// 绘制路径
- (UIBezierPath *)path {
    
    // 椭圆
    //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.view.bounds];
    // 圆角矩形
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:50];
    // 内切圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 100, 300, 300)];
    
    // 贝塞尔曲线
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, Height)];
//    CGPoint point_1 = CGPointMake(Width, Height);
//    CGPoint controPoint_1 = CGPointMake(Width / 2, - Height);
//    //    CGPoint controPoint_2 = CGPointMake(TScreenWidth / 4 * 3, TScreenHeight);
//    
//    [path addQuadCurveToPoint:point_1 controlPoint:controPoint_1];
    //    [path addCurveToPoint:point_1 controlPoint1:controPoint_1 controlPoint2:controPoint_2];
    
    return path;
}

@end
