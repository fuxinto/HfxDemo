//
//  ViewController.m
//  NSURLSession(后台下载)
//
//  Created by tens04 on 16/9/6.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIView *prograssView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)downloadAction:(UIButton *)sender {
    
    [self sessionDownload];
}

- (void)sessionDownload {
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/fuqinglin/MagicalRecord/archive/master.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
    
    // 设置网络请求为 backgroundSessionConfigurationWithIdentifier 后台模式
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.tens.background"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    
    [downloadTask resume];
}

#pragma mark - <NSURLSessionDownloadDelegate>
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"下载完成");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    
    NSLog(@"%lld %lld %lld",bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}


// 后台下载完调用
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    NSLog(@"后台下载完成");
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    // 回调 AppDelegate 中 application: handleEventsForBackgroundURLSession: completionHandler: 中的block事件，处理下载完后的提示
    if (delegate.backgroundCompletionHandler) {
        
        void (^completionHandler)() = delegate.backgroundCompletionHandler;
        
        completionHandler();
        
        delegate.backgroundCompletionHandler = nil;
        
    }
}
@end
