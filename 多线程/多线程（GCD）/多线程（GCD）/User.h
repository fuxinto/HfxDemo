//
//  User.h
//  多线程（GCD）
//
//  Created by tens04 on 16/9/3.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSString *userName;


+ (instancetype)shareUser;

@end
