//
//  Model.m
//  UIWebView与JS交互
//
//  Created by tens04 on 16/9/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "Model.h"
#import "MBProgressHUD.h"


@interface Model()

@property(strong, nonatomic)MBProgressHUD *HUD;

@end

@implementation Model


#pragma mark - JSObjcDelegate

- (void)callCamera {
    
    NSLog(@"点击了网页按钮");
    
    JSValue *picCallback = self.jsContext[@"picCallback"];
    //参数传递
    [picCallback callWithArguments:@[@"请看Xcode！"]];
}

- (void)share:(id)shareString {
    
    NSLog(@"share:%@", shareString);
    
    NSData *json = [shareString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 将json格式数据解析为对应的数据类型（数组、字典、字符串、数字）
    NSError *error = nil;
    // NSJSONReadingMutableContainers: 转为对应的可变容器（可变数组、可变字典）
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"%@",jsonData[@"shareUrl"]);
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonData[@"shareUrl"]]];
    
    // 分享成功回调js的方法shareCallback
    JSValue *shareCallback = self.jsContext[@"shareCallback"];
    
    [shareCallback callWithArguments:@[@"保存成功"]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    // 将图片保存到相册中
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

#pragma mark - MBProgressHUD 提示框
- (void)shwoHUD:(NSString *)message {
    
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.webView];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.removeFromSuperViewOnHide = YES;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attitude_uncheck"]];
        _HUD.labelText = message;
    }
    [self.webView addSubview:_HUD];
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:2.0];
    
}


#pragma mark - 图片\video 保存后的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *str;
    
    if (!error) {
        
        str= @"图片保存成功！";
    }else {
        
        str =  @"图片保存失败";
    }
    
        [self shwoHUD:str];
}
@end
