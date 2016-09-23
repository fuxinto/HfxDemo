//
//  ViewController.m
//  CoreGraphics绘图
//
//  Created by tens04 on 16/9/1.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "CoreGraphicsView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoreGraphicsView *cgView = [[CoreGraphicsView alloc] initWithFrame:self.view.bounds];
    cgView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:cgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
