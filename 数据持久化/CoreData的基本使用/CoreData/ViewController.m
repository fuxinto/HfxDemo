//
//  ViewController.m
//  CoreData
//
//  Created by tens04 on 16/9/2.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "User+CoreDataProperties.h"
#import "Book+CoreDataProperties.h"
#import "AppDelegate.h"
@interface ViewController () {
    
    AppDelegate *delegate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    delegate = [UIApplication sharedApplication].delegate;
    
    //    delegate.managedObjectContext;
    
    //  [self insertObject];
    
    // [self updateObject];
    // [self findObject];
    
    [self deleteObject];
    
}

#pragma mark - 添加
- (void)insertObject {
    
    // 创建实体对象
    // NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
    
    //添加一个实体对象到 managedObjectContext 中
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
    user.userID = @10002;
    user.userName = @"怀化";
    user.userAge = @30;
    user.userSex = @"男";
    user.userDate = [NSDate date];
    
    // 2、保存上下文
    [delegate saveContext];
}

#pragma mark - 查询
- (void)findObject {
    
    // 1、创建一个取值请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    // 使用谓词设置查询条件
    // request.predicate = [NSPredicate predicateWithFormat:@"userAge < 35"];
    // request.predicate = [NSPredicate predicateWithFormat:@"userName LIKE '*杨*'"];
    
    // 设置查询的条数
    request.fetchLimit = 2;
    
    // 指定到某个位置开始查询（分页效果）
    request.fetchOffset = 2;
    
    // 按某个字段升序、降序排列
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userAge" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSError *error = nil;
    // 2、在上下文中执行取值请求
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        User *user = (User *)obj;
        
        NSLog(@"%@ %@ %@ %@ %@",user.userID, user.userName, user.userAge, user.userSex, user.userDate);
    }];
    
}

#pragma mark - 更新
- (void)updateObject {
    
    // 1、查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID == '10005'"];
    
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2、修改
        User *user = (User *)obj;
        user.userDate = [NSDate date];
        
        // 3、保存
        [delegate saveContext];
    }];
}

#pragma mark - 删除
- (void)deleteObject {
    
    // 1、查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID == '10005'"];
    
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2、删除
        [delegate.managedObjectContext deleteObject:obj];
        
        // 3、保存
        [delegate saveContext];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
