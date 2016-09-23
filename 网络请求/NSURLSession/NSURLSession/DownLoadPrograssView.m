//
//  DownLoadPrograssView.m
//  04、绘图实例
//
//  Created by kinglinfu on 16/8/30.
//  Copyright © 2016年 Tens. All rights reserved.
//

#import "DownLoadPrograssView.h"

@implementation DownLoadPrograssView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 20;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 20;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
}


- (void)setPrograss:(CGFloat)prograss {
    
    _prograss = prograss;
    // 重新绘制
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    [self drawPrograssPath];
    [self drawText];
}


- (void)drawPrograssPath {
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = self.bounds.size.width / 2 - 10;
    
    CGFloat endAngle = M_PI * 2 * _prograss - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius  startAngle:- M_PI_2 endAngle: endAngle clockwise:YES];
//    [path addLineToPoint:center];
//    [path closePath];
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor whiteColor] setStroke];
//    [[UIColor lightGrayColor] setFill];
    
    [path stroke];
//    [path fill];
    
}

- (void)drawText {
    
    NSString *text = [NSString stringWithFormat:@"%.1f %%",_prograss * 100];
    
    CGFloat x = (self.bounds.size.width - 90) / 2;
    CGFloat y = (self.bounds.size.height - 30) / 2;
    
    [text drawAtPoint:CGPointMake(x, y) withAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:30]}];

}


@end
