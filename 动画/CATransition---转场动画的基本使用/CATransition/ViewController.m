//
//  ViewController.m
//  CATransition
//
//  Created by tens04 on 16/8/27.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    UIImageView *imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageView = [[UIImageView alloc]init];
    imageView.bounds =  [UIScreen mainScreen].bounds;
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"large_0"];
    [self.view addSubview:imageView];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    static int index = 1;
    
    [imageView.layer addAnimation:[self transitionAnimation] forKey:nil];
    
    NSString *imageName = [NSString stringWithFormat:@"large_%d.jpg",index];
    imageView.image = [UIImage imageNamed:imageName];
    
    index++;
    
    if (index > 10) {
        
        index = 0;
    }
    
}


- (CAAnimation *)transitionAnimation {
    
    CATransition *transitionAni = [CATransition animation];
    transitionAni.duration = 1.0;
    /*
     1. fade     淡出效果
     2. moveIn 进入效果
     3. push    推出效果
     4. reveal   移出效果
     
     // 未公开的
     5. cube   立方体翻转效果
     6. suckEffect  抽走效果
     7. rippleEffect 水波效果
     8. pageCurl    翻开页效果
     9. pageUnCurl 关闭页效果
     10. cameraIrisHollowOpen  相机镜头打开效果
     11.  cameraIrisHollowClose  相机镜头关闭效果
     */
    
    transitionAni.type = kCATransitionPush;
    // transitionAni.type = @"push";
    
    // 转场的方向：`fromLeft', `fromRight', `fromTop'  `fromBottom'
    transitionAni.subtype = @"fromRight";
    
    // 开始转场和结束转场的进度位置
    // transitionAni.startProgress = 0.5;
    // transitionAni.endProgress = 1;
    
    return transitionAni;
}

@end
