//
//  pathThreeViewController.m
//  homework
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "pathThreeViewController.h"
#import "pathThree.h"
@interface pathThreeViewController () {
    pathThree *prograssView;
}

@end

@implementation pathThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     prograssView = [[pathThree alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
     prograssView.center = self.view.center;
     [self.view addSubview:prograssView];
    

}
#pragma mark - 进度条数据
- (IBAction)slider:(UISlider *)sender {
    
    prograssView.prograss = sender.value;
}

@end
