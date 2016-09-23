//
//  AppDelegate.h
//  NSURLSession(后台下载)
//
//  Created by tens04 on 16/9/6.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) void(^backgroundCompletionHandler)();



@end

