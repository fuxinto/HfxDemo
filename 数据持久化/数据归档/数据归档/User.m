//
//  User.m
//  数据归档
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - <NSCoing> 对属性编码和解码
// 编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_password forKey:@"password"];
}


// 解码
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self ) {
        
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
    }
    
    return self;
}


@end
