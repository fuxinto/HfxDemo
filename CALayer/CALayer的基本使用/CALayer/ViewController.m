//
//  ViewController.m
//  CALayer
//
//  Created by tens04 on 16/8/24.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#define Width 50
@interface ViewController (){
    
    CALayer *layer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    
    // 1、bounds： 尺寸
    layer.bounds = CGRectMake(0, 0, Width, Width);
    // 2、position: 定位点
    layer.position = CGPointMake(Width/2, Width/2);
    
    // 3、锚点、支点：决定layer上的哪个点在 position 点上，默认(0.5, 0.5)，范围：（0，0） ~ （1，1）
    layer.anchorPoint = CGPointMake(0.5, 0.5);
  
    [self.view.layer addSublayer:layer];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[touches anyObject];
    CGFloat width=layer.bounds.size.width;
    
    if (width==Width) {
        width=Width*2;
        // 组合 CATransform3D
        CATransform3D transform_01 = CATransform3DScale(layer.transform, 1, 1, 1);
        CATransform3D transform_02 = CATransform3DRotate(layer.transform, M_PI/6, 0, 0, 1);
        layer.transform = CATransform3DConcat(transform_01, transform_02);
        layer.cornerRadius = width/2;
        layer.backgroundColor = [UIColor blueColor].CGColor;
    }else{
        width=Width;
        layer.cornerRadius = 0;
        layer.backgroundColor = [UIColor orangeColor].CGColor;
    }
    layer.bounds=CGRectMake(0, 0, width, width);
    layer.position=[touch locationInView:self.view];
    
}
@end
