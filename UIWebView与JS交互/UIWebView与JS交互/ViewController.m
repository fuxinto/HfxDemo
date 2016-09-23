//
//  ViewController.m
//  UIWebView与JS交互
//
//  Created by tens04 on 16/9/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) void (^MyBlock)();
@end

typedef NS_ENUM ( NSInteger, Type ) {
    TypeReload = 1 ,
    TypeStopLoading,
    TypeGoBack,
    TypeGoForward
};


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    self.webView.scalesPageToFit = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;

}


- (IBAction)WKwebView:(id)sender {
    
    WKWebViewController  *jsVC = [[WKWebViewController alloc]init];
    [self presentViewController:jsVC animated:YES completion:nil];
    
    
}

- (IBAction)actionClick:(UIButton *)sender {
    switch (sender.tag) {
        case TypeReload: {
            //刷新
            [self.webView reload];
        }
            break;
        case TypeStopLoading: {
            //停止
            [self.webView stopLoading];
        }
            break;
        case TypeGoBack: {
            //返回
            [self.webView goBack];
        }
            break;
        case TypeGoForward: {
            //前进
            [self.webView goForward];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // NSLog(@"StartLoadWithRequest");
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    //  NSLog(@"开始加载");
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // NSLog(@"加载失败");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //获取当前页面的title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.title = title;
    // 获取当前页面的url
    NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    if ([title compare:@"百度一下"] == NSOrderedSame) {
        
        NSString *jsCode = [NSString stringWithFormat:@"alert('用户%@登录成功')",self.userName];
        
        [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
    }
    
    NSLog(@"%@/n，%@",title,url);
    __weak typeof(self)weakSelf = self;
    
    self.MyBlock = ^() {
        if ([title compare: @"百度一下"]== NSOrderedSame ) {
            
            NSString *str = [NSString stringWithFormat:@"var script = document.createElement('script');"
                             "script.type = 'text/javascript';"
                             "script.text = \"function myFunction() { "
                             "var field = document.getElementsByName('q')[0];"
                             "field.value='%@';"
                             "document.forms[0].submit();"
                             "}\";"
                             "document.getElementsByTagName('head')[0].appendChild(script);",weakSelf.userName];
            
            [webView stringByEvaluatingJavaScriptFromString:str];
            
            [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
        }
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
