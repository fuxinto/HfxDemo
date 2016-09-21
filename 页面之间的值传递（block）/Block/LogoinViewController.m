//
//  ViewController.m
//  Block
//
//  Created by tens04 on 16/8/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "LogoinViewController.h"
#import "RegistViewController.h"
@interface LogoinViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@end

@implementation LogoinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
        
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RegistViewController *registVC = segue.destinationViewController;
    
    // 定义block, 接收调用时传入的参数
    registVC.userBlock = ^(NSString *userName, NSString *password) {
        
        self.userName.text = userName;
        self.userPassword.text = password;
    };
}
@end
