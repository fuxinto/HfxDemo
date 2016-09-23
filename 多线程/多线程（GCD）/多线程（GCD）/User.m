//
//  User.m
//  多线程（GCD）
//
//  Created by tens04 on 16/9/3.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "User.h"
static User *user = nil;

@implementation User

// 这种单例不是线程安全的
+ (instancetype)shareUser {
    
    static User *user = nil;
    
    if (user == nil) {
        
        user = [[self alloc] init];
    }
    
    return user;
}

// 线程安全的单例创建
+ (instancetype)shareUser_GCD {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    
    return user;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static User *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [super allocWithZone:zone];
    });
    
    return user;
}
@end
