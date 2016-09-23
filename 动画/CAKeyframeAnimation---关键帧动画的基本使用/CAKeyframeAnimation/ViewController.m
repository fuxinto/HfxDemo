//
//  ViewController.m
//  CAKeyframeAnimation
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
    //创建核心动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 4;
    //    keyAnimation.autoreverses = YES;
    keyAnimation.repeatCount = HUGE_VALF;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.removedOnCompletion = NO;
    
    //要执行的动画
     NSValue *point_1 = [NSValue valueWithCGPoint:CGPointMake(Width / 2,0)];
     NSValue *point_2 = [NSValue valueWithCGPoint:CGPointMake(50,Height / 2)];
     NSValue *point_3 = [NSValue valueWithCGPoint:CGPointMake(Width / 2,Height - 50)];
     NSValue *point_4 = [NSValue valueWithCGPoint:CGPointMake(Width - 50,Height / 2)];
     NSValue *point_5 = [NSValue valueWithCGPoint:CGPointMake(Width / 2,0)];
     
     // values:设置关键帧(多个目标点)
     keyAnimation.values = @[point_1,point_2,point_3,point_4,point_5];
     
     // 设置每一帧所在的时间比例
     keyAnimation.keyTimes = @[@0, @0.2, @0.5, @0.6,@1.0];
     
    
    /* 插值计算模式：
     kCAAnimationLinear  关键帧之间进行插值计算（线性的）
     kCAAnimationDiscrete 关键帧之间不进行插值计算（离散的）
     kCAAnimationPaced 关键帧之间匀速切换，keyTimes\timingFunctions的设置将不起作用
     kCAAnimationCubic 关键帧进行圆滑曲线相连后插值计算
     kCAAnimationCubicPaced 匀速并且关键帧进行圆滑曲线相连后插值计算
     */
    keyAnimation.calculationMode = kCAAnimationLinear;

    return keyAnimation;
    
}

@end
