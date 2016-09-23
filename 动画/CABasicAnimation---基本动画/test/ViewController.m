//
//  ViewController.m
//  test
//
//  Created by tens04 on 16/8/26.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
{
    CALayer *anilayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    anilayer = [CALayer layer];
    anilayer.frame = CGRectMake(100, 50, 100, 100);
    anilayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"足球"].CGImage);
    [self.view.layer addSublayer:anilayer];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 给layer 添加动画
    // 给layer 添加动画
    [anilayer addAnimation:[self positionAnimation] forKey:@"position"];
    [anilayer addAnimation:[self rotationAnimation] forKey:@"rotation"];
    
    [anilayer addAnimation:[self boundsAnimation] forKey:@"bounds"];

    [anilayer addAnimation:[self scaleAnimation] forKey:@"scale"];
    
}

- (CAAnimation *)scaleAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 1、初始值
    animation.fromValue = @1.0;
    // 2、目标值
    animation.toValue = @2.0;
    
    // 3、变化的值， fromValue ~ toValue 值的变化量
    // animation.byValue = @1.0;
    
    // 4、动画时间
    animation.duration = 2.0;
    
    /* 5、动画的填充模式：
     kCAFillModeForwards
     kCAFillModeBackwards
     kCAFillModeBoth
     kCAFillModeRemoved
     */
    animation.fillMode = kCAFillModeForwards;
    
    // 6、动画后是否移除动画后的状态(回到原始状态)，默认是YES, 前提是要设置fillModle为：kCAFillModeForwards
    animation.removedOnCompletion = NO;
    
    // 7、是否有回复效果
    animation.autoreverses = YES;
    
    // 8、设置动画重复次数
    animation.repeatCount = HUGE_VALF; //  HUGE_VALF 最大浮点数，表示无限次重复
    
    // 9、播放动画的速度
    animation.speed = 2;
    
    return animation;
}

- (CAAnimation *)rotationAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // animation.fromValue = @0;
    // animation.toValue = @(2 * M_PI);
    animation.byValue = @( -2 * M_PI);
    
    animation.duration = 2.0;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF; //  HUGE_VALF 最大浮点数，表示无限次重复
    
    return animation;
}


- (CAAnimation *)boundsAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 300)];
    
    animation.duration = 2.0;
    
    return animation;
}



- (CAAnimation *)positionAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    //设置初始值
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 50)];
    //设置结束值
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 550)];
    //动画时间
    animation.duration = 2.0;
    //填充模式
    animation.fillMode = kCAFillModeForwards;
    //动画结束后是否自动移除
    animation.removedOnCompletion = NO;
    //反转动画
    animation.autoreverses = YES;
    //循环次数
    animation.repeatCount = HUGE_VALF; //  HUGE_VALF 最大浮点数，表示无限次重复
    
    /* 动画的线性变换(动画速度变化)
     kCAMediaTimingFunctionLinear 匀速
     kCAMediaTimingFunctionEaseIn 加速
     kCAMediaTimingFunctionEaseOut 减速
     kCAMediaTimingFunctionEaseInEaseOut 缓慢进入缓慢出去
     kCAMediaTimingFunctionDefault 默认
     */
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}
@end
