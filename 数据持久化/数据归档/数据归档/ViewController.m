//
//  ViewController.m
//  数据归档
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"info.archiv"];
    
    
    NSArray *infos = @[@"1",@"2",@"3"];
    
    // 归档自定义的对象的前提是要实现 <NSCoding> 协议，对对象的属性进行编码和解码
    User *user = [[User alloc] init];
    user.userName = @"qwertyu";
    user.password = @"1234567";
    
    // 1、归档(编码保存)：将数据以二进制的形式保存，常用的NSString、NSArray、NSDictionary.... 可以直接归档保存，因为它们都实现了 <NSCoding> 协议 ： NSKeyedArchiver
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:user toFile:filePath];
    
    if (isSuccess) {
        
        NSLog(@"成功");
    } else {
        
        NSLog(@"失败");
    }
    
    NSLog(@"%@",docPath);
    
    
    // 2、解归档(读取解码)： NSKeyedUnarchiver
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    User *user_ = (User *)object;
    NSLog(@"%@  %@",user_.userName, user_.password);
    
    
}
@end
