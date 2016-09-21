//
//  ViewController.m
//  CALaye---ClockDemo
//
//  Created by tens04 on 16/8/24.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

//宏
#define PerSecondA  2 * M_PI / 60    //秒针：每秒6度（360/6）
#define PerMintueA  2 * M_PI / 60    //分针：每分钟6度
#define PerHourA    2 * M_PI / 12     //时针：每小时30度

#define PerMinHourA 2 * M_PI / 12 / 60   // 每分钟时针转 30 / 60 °
@interface ViewController (){
    NSInteger secondData;
    NSInteger minuteData;
    NSCalendar *calendar;
}
@property (strong, nonatomic) NSDateComponents *comps;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CALayer *layerS;
@property (strong, nonatomic) CALayer *layerM;
@property (strong, nonatomic) CALayer *layerH;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    [self.view.layer addSublayer:self.layerS];
    [self.view.layer addSublayer:self.layerM];
    [self.view.layer addSublayer:self.layerH];
    //开始运行时获取时间
    [self currentTime];
    
    //添加定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(currentTime) userInfo:nil repeats:YES];

}


- (void)currentTime {

    //计算时针、分针、秒针转动的角度
    CGFloat secondA = self.dateComponents.second *PerSecondA;
    CGFloat minuteA = self.dateComponents.minute *PerMintueA;
    CGFloat hourA = self.dateComponents.hour *PerHourA + self.dateComponents.minute *PerMinHourA;
    
    //旋转时针、分针、秒针
    self.layerS.transform = CATransform3DMakeRotation(secondA, 0, 0, 1);
    self.layerM.transform = CATransform3DMakeRotation(minuteA, 0, 0, 1);
    self.layerH.transform = CATransform3DMakeRotation(hourA, 0, 0, 1);
}
    


- (NSDateComponents *)dateComponents {
    
    if (calendar == nil) {
        
        // 获取当前地点日历
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    }
    
    // 根据日历获取日期的组成部分
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour  fromDate:[NSDate date]];
    
    return dateComponents;
}



- (void)loadDate {
    
    //获取当前系统时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    self.comps = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour  fromDate:[NSDate date]];
        // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    
    
    
    
    self.layerS.transform = CATransform3DRotate(self.layerS.transform, (M_PI/30)*self.comps.second, 0, 0, 1);
    secondData = self.comps.second;
    self.layerM.transform = CATransform3DRotate(self.layerM.transform, (M_PI/30)*self.comps.minute, 0, 0, 1);
    minuteData = self.comps.minute;
    self.layerH.transform = CATransform3DRotate(self.layerH.transform, (M_PI/6)*self.comps.hour , 0, 0, 1);
    
    self.layerH.transform = CATransform3DRotate(self.layerH.transform,(M_PI/30)*(self.comps.minute/12) , 0, 0, 1);

}

- (NSTimer *)timer {
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(currentTime) userInfo:nil repeats:YES];
    }
    return _timer;
}



- (CALayer *)layerS {
    if (!_layerS) {
        // 1、创建layer
        _layerS = [[CALayer alloc] init];
        // 1、bounds： 尺寸
        _layerS.bounds = CGRectMake(0, 0, 9, 140);
        // 2、position: 定位点
        _layerS.position = self.view.center;
        
        // 3、锚点、支点：决定layer上的哪个点在 position 点上，默认(0.5, 0.5)，范围：（0，0） ~ （1，1）
        _layerS.anchorPoint = CGPointMake(0.5, 1);
        
        // 3、填充图片内容，需要将 UIImage 桥接(__bridge)到CGImage
        _layerS.contents = (__bridge id _Nullable)([UIImage imageNamed:@"secondHand"].CGImage);
    }
    return _layerS;
}

- (CALayer *)layerH {
    if (!_layerH) {
        _layerH = [[CALayer alloc]init];
        _layerH.bounds = CGRectMake(0, 0, 27, 120);
        _layerH.position = self.view.center;
        _layerH.anchorPoint = CGPointMake(0.5, 1);
        _layerH.contents = (__bridge id _Nullable)([UIImage imageNamed:@"hourHand"].CGImage);
    }
    return _layerH;
}

- (CALayer *)layerM {
    if (!_layerM) {
        _layerM = [[CALayer alloc]init];
        _layerM.bounds = CGRectMake(0, 0, 21, 128);
        _layerM.position = self.view.center;
        _layerM.anchorPoint = CGPointMake(0.5, 1);
        _layerM.contents = (__bridge id _Nullable)([UIImage imageNamed:@"minuteHand"].CGImage);
    }
    return _layerM;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dial"]];
        _imageView.center = self.view.center;
    }
    return _imageView;
}

@end
