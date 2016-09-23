//
//  ViewController.m
//  NSURLSession
//
//  Created by tens04 on 16/9/5.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadPrograssView.h"

#define APPID @"24110"
#define SIGN  @"c3ea2bc9a95e40299a92f79747e57cf8"

@interface ViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet DownLoadPrograssView *prograssView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self sessionURl_GET];
//    [self sessionURL_POST];
    [self sesssionTask_Configuration];
    [self download_delegate];
}

#pragma mark - GET请求
- (void)sessionURl_GET {

    // GET请求：获取数据，把参数以URL的形式拼接传给服务器，以 ？ 分开URL地址和参数，& 拼接多个参数
    NSString *urlStr = @"https://route.showapi.com/213-4?showapi_appid=24110&showapi_timestamp=20160905154834&topid=5&showapi_sign=5d1ba1725827501e32238072e5960958";
    //创建一个URL
    NSURL *URL = [NSURL URLWithString:urlStr];
    
    // 2、创建一个NSURLRequest 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3、创建NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 4、由session创建一个请求数据的任务NSURLSessionDataTask,(会以异步的形式发送网络请求,不会阻塞主线程)
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 执行完后 以block 返回结果，解析数据
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",jsonData);

        
    }];
    
    // 5、开始执行网络任务
    [dataTask resume];
    
}


#pragma mark - POST请求
- (void)sessionURL_POST {
    // POST请求时要指明请求的方式HTTPMethod 为 POST,参数以请求体 HTTPMethod 的形式传入。
    
    NSURL *url = [NSURL URLWithString:@"https://route.showapi.com/213-4"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 1、设置请求方式为 POST
    request.HTTPMethod = @"POST";
    
    NSString *parmStr = [NSString stringWithFormat:@"showapi_appid=%@&showapi_timestamp=%@&topid=%@&showapi_sign=%@",APPID,@"20160905154834",@"5",SIGN];
    // 2、设置请求体：把参数作为NSData类型传入
    request.HTTPBody = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        // NSLog(@"%@",response);
        
        // 执行完后 以block 返回结果，解析数据
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",jsonData);
        
    }];
    
    [dataTask resume];

}

#pragma mark - 网络请求配置
- (void)sesssionTask_Configuration {
    
    
    NSString *urlStr = @"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv-001.jpg";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    /* 设置缓存策略：cachePolicy
     
     NSURLRequestUseProtocolCachePolicy = 0, // 默认，使用缓存，当下一次请求时先判断是否有缓存，有就使用缓存没有才进行网络请求，使用缓存时会先判断缓存是否过期，过期的就重新请求网络。
     NSURLRequestReloadIgnoringLocalCacheData = 1, // 忽略缓存，不使用缓存
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // 无视任何的缓存策略，无论是本地的还是远程的，总是从原地址重新下载
     NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,
     
     NSURLRequestReturnCacheDataElseLoad = 2, 首先使用缓存不管是否过期，如果没有本地缓存，才从原地址下载
     
     NSURLRequestReturnCacheDataDontLoad = 3, 使用本地缓存，从不下载，如果本地没有缓存，则请求失败。此策略多用于离线操作
     
     NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
     
     
     timeoutInterval: 设置请求超时的时间秒数
     
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    
    
    /* NSURLSessionConfiguration：配置网络请求
     
     defaultSessionConfiguration, 默认的模式，可以缓存数据
     ephemeralSessionConfiguration, 无痕浏览，不会有任何的缓存
     backgroundSessionConfigurationWithIdentifier
     */
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 通过 NSURLSessionConfiguration 设置缓存策略
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        NSLog(@"%@",response);
        //返回主线程更改UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];
            
        });
        
    }];
    
    
    [dataTask resume];
    
}


#pragma mark - block方式下载
- (void)downloadTask_block {
    
    NSURL *url = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/108051051.mp3?vkey=4A95A0FCDFDC050E9D543841CA4A28AABD19F1973177DAB509EEBED09344D0A91A286D0800E7C58751A670CC429DB1118C98F8908C487284&guid=2718671044"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // 1、创建一个下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        // 2、设置保存文件的本地URL
        NSURL *docmentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *dataURL = [docmentsURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        NSError *moveError = nil;
        // 3、将下载的数据从临时URL移动到指定的URL
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:dataURL error:&moveError];
        if (!moveError) {
            
            NSLog(@"保存成功");
        }
        
        NSLog(@"%@",location);
        
    }];
    
    [downloadTask resume];
}



#pragma mark - 代理的方式下载
- (void)download_delegate {
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/AFNetworking/AFNetworking/archive/master.zip"];
    
    // 1、配置NSURLSession并设置代理，delegateQueue：代理执行的线程
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithURL:url];
    
    [downTask resume];
    
}

#pragma mark - <NSURLSessionDownloadDelegate>
//下载完成后调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"下载完成 %@",NSHomeDirectory());
    
    NSURLConnection
    // 1、设置保存文件的本地URL
    NSURL *docmentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *dataURL = [docmentsURL URLByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    NSError *moveError = nil;
    // 2、将下载的数据从临时URL移动到指定的URL
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:dataURL error:&moveError];
    if (!moveError) {
        
        NSLog(@"保存成功");
    }
}


// 监听下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    // bytesWritten: 时间点下载的数据大小 totalBytesWritten：已经下载的数据大小，totalBytesExpectedToWrite: 下载文件的总大小
    
    self.prograssView.prograss = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    NSLog(@"%lld, %lld, %lld ",bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

/*图片上传地址：
 http://www.chuantu.biz/#upload
 
 http://www.imageshack.us/index.php
 */



@end


