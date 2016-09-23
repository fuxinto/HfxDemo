//
//  ViewController.m
//  属性列表
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self userDefaults];
    
    [self propertyList];
    
}

- (void)propertyList {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    
    
    NSMutableDictionary *userInfos = [NSMutableDictionary dictionary];
    [userInfos setObject:@"admin" forKey:@"userName"];
    [userInfos setObject:@"55244646435@qq.com" forKey:@"email"];
    
    // 1、将字典数据写入plist文件
    BOOL isSuccess_1 = [userInfos writeToFile:filePath atomically:YES];
    
    
    NSString *filePath_array = [docPath stringByAppendingPathComponent:@"infos.plist"];
    NSArray *infos = @[@"1",@"2",@"3"];
    
    // 2、将数组数据写入plist文件
    BOOL isSuccess_2 =  [infos writeToFile:filePath_array atomically:YES];
    
    
    if (isSuccess_2) {
        NSLog(@"数据写入成功");
    } else {
        
        NSLog(@"写入失败");
    }
    
    // 3、NSString 、NSNumber、NSdate、NSData、boolean 类型数据同理
    NSLog(@"%@",docPath);
    
    
    // 4、获取本地路径的plist文件
    NSArray *infos_ = [NSArray arrayWithContentsOfFile:filePath_array];
    // NSDictionary *userInfos = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@",infos);
}


#pragma mark - NSUserDefaults
- (void)userDefaults {
    
    // NSUserDefaults 系统提供的plist文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 设值
    [userDefaults setObject:@100 forKey:@"id"];
    [userDefaults setBool:YES forKey:@"isLoad"];
    [userDefaults setDouble:3.8408 forKey:@"price"];
    
    
    // 数据同步(即使更新数据)
    [userDefaults synchronize];
    
    // 取值
    id value = [userDefaults objectForKey:@"id"];
    NSLog(@"%@",value);
    
    // 修改
    [userDefaults setObject:@2000 forKey:@"id"];
    [userDefaults synchronize];
    
    
    NSLog(@"%@",NSHomeDirectory());
    
    
}
@end
