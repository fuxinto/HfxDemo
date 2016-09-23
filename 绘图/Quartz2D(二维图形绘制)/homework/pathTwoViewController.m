//
//  pathTwoViewController.m
//  homework
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "pathTwoViewController.h"
#import "pathTwo.h"
@interface pathTwoViewController ()

@end

@implementation pathTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pathTwo *path = [[pathTwo alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:path];
}

@end
