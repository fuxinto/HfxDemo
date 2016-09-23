//
//  ViewController.m
//  resume
//
//  Created by tens04 on 16/8/27.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    
    CALayer *layer;
    
    BOOL _isPause;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 250, 250);
    layer.position = self.view.center;
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"get.jpeg"].CGImage);
    
    [self.view.layer addSublayer:layer];
    
    [self rotationAnimation];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_isPause) {
        
        [self resumeAnimation];
        
    }else {
        
        [self pauseAnimation];
    }
    
    _isPause = !_isPause;
    
}

- (void)pauseAnimation {
    
    NSLog(@"CACurrentMediaTime:%f",CACurrentMediaTime());
    
    // CACurrentMediaTime(): 当前媒体时间，表示系统启动后到当前的秒数，当系统重启后这个时间也重置
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 设置动画的时间的偏移
    layer.timeOffset = pauseTime;
    
    layer.speed = 0;
}


- (void)resumeAnimation {
    
    // 获取暂停时的时间
    CFTimeInterval pasuseTime = [layer timeOffset];
    
    layer.speed = 1;
    layer.timeOffset = 0;
    layer.beginTime = 0;
    
    // 设置开始的时间(继续动画，这样设置相当于让动画等待的秒数等于暂停的秒)
    layer.beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pasuseTime;
}



- (CAAnimation *)rotationAnimation {
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.duration = 2.0;
    animation.byValue = @(2 * M_PI);
    animation.repeatCount = HUGE_VALF;
    
    // 设置动画开始的媒体时间（用于设置动画的延迟启动）,要加上CACurrentMediaTime
    animation.beginTime =  CACurrentMediaTime() + 2;
    
    [layer addAnimation:animation forKey:@"rotaion"];
    
    return animation;
}
@end
