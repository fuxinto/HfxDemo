//
//  ViewController.m
//  绘图
//
//  Created by tens04 on 16/8/29.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "BezierPathView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BezierPathView *pathView = [[BezierPathView alloc]initWithFrame:self.view.bounds];
        
    [self.view addSubview:pathView];
}
@end
