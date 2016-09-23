//
//  pathTwo.m
//  homework
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "pathTwo.h"

@implementation pathTwo

- (void)drawRect:(CGRect)rect {
    [self drawPathThree];
}

#pragma mark - 绘制饼形图
- (void)drawPathThree {
    
    NSArray *values = @[@20,@30,@15,@10,@25];
    NSArray *colors = @[[UIColor orangeColor], [UIColor blueColor], [UIColor greenColor], [UIColor whiteColor],[UIColor redColor]];
    
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    
    for(int i = 0; i < values.count; i++) {
        
        NSNumber *value = values[i];
        // 根据比例计算终端位置
        endAngle += M_PI * 2 * value.doubleValue / 100.0;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:150 startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:self.center];
        [path closePath];
        [colors[i] setFill];
        //        [[UIColor lightGrayColor] setStroke];
        path.lineWidth = 5;
        //        [path stroke];
        [path fill];
        
        startAngle = endAngle;
    }
}
@end
