//
//  ViewController.m
//  PodTest
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db.sqlite"];
    
    NSLog(@"%@",path);
    // 1、创建数据库对象
    FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
    
    // 2、打开数据库，打开失败直接返回
    if (![dataBase open]) {
        
        NSLog(@"打开失败");
        return;
    }
    
    //  NSString *sql = @"CREATE TABLE IF NOT EXISTS User('userID' TEXT,'userName' TEXT)";
    // BOOL isSuccess = [dataBase executeUpdate:sql];
    
    
    NSString *sql = @"INSERT INTO User('userId','userName') VALUES (?,?)";
    
    //3、executeUpdate：执行非查询sql语句，可以接受多个参数
    BOOL isSuccess = [dataBase executeUpdate:sql,@"10002",@"王五"];
    if (isSuccess) {
        
        NSLog(@"完成");
    } else {
        
        NSLog(@"失败");
    }
    
    NSString *sql_query = @"SELECT *FROM User";
    
    // 4、executeQuery： 查询数据
    FMResultSet *set = [dataBase executeQuery:sql_query];
    int count = [set columnCount];
    NSLog(@"count: %d",count);
    
    // 5、[set next] 表示有下一个数据
    while ([set next]) {
        
        // 根据字段所在列的坐标取值
        // NSString *userID =  [set objectForColumnIndex:0];
        // NSString *userName = [set objectForColumnIndex:1];
        // int userAge = [set intForColumnIndex:2];
        
        // 根据字段名取值
        NSString *userID =  [set objectForColumnName:@"userID"];
        NSString *userName = [set objectForColumnName:@"userName"];
        
        NSLog(@"%@, %@", userID, userName);
    }
    
    
    //6、使用完后关闭数据库
    [dataBase close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
