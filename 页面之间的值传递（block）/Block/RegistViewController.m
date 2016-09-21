//
//  RegistViewController.m
//  Block
//
//  Created by tens04 on 16/8/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)registAction:(UIButton *)sender {
    // 调用block(回调)，传入参数完成数据的通信
    self.userBlock(_userName.text, _passWord.text);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
