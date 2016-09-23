//
//  Model.h
//  UIWebView与JS交互
//
//  Created by tens04 on 16/9/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>
//协议方法
- (void)callCamera ;
- (void)share:(id)shareString ;
@end



@interface Model : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, weak) UIWebView *webView;
//@property (strong, nonatomic) MBProgressHUD *HUD;

@end
