//
//  WebViewController.m
//  UIWebView与JS交互
//
//  Created by tens04 on 16/9/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "WebViewController.h"
#import "Model.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *jsContext;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    //创建NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载
    [_webView loadRequest:request];
    
    _webView.delegate = self;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    Model *model  = [[Model alloc] init];
    self.jsContext[@"Toyun"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
