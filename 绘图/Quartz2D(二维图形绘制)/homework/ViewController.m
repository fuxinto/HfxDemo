//
//  ViewController.m
//  homework
//
//  Created by tens04 on 16/8/29.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "pathView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pathView *path = [[pathView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
