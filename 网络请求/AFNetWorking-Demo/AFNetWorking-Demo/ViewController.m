//
//  ViewController.m
//  AFNetWorking-Demo
//
//  Created by tens04 on 16/9/6.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

//#import <AFNetworking/AFHTTPSessionManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self afnetworking_GET];
    
    //    [self afnetworking_POST];
    
    //    [self afnetworking_Download];
    
    //    [self afnetworking_Upload];
    
    [self afnetworking_Reachability];
    
    NSLog(@"%@",NSHomeDirectory());
    
}

#pragma mark - 网络检测
- (void)afnetworking_Reachability {
    
    // 1、监听网络的改变
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 2、网络改变后调用的方法，可以检测到不同类型的网络。
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                NSLog(@"为止网络");
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                NSLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                NSLog(@"wifi");
                
                [self afnetworking_Download];
                // [self afnetworking_Upload];
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                // 蜂窝网络，这里提醒是否可以进行大流量的操作（播放视频、下载数据、上传大数据）
                NSLog(@"WWAN");
                
                break;
                
            default:
                break;
        }
        
    }];
    
    
}

#pragma mark - GET请求
- (void)afnetworking_GET {
    
    // 1、创建AFHTTPSessionManager 相当于NSURLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // AFHTTPSessionManager *manager = [AFHTTPSessionManager alloc] initWithBaseURL:@"" sessionConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@""];
    
    NSString *urlStr = @"http://route.showapi.com/213-4";
    
    // 2、使用字典的形式拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"16246" forKey:@"showapi_appid"];
    [params setObject:@"20160906141407" forKey:@"showapi_timestamp"];
    [params setObject:@"5" forKey:@"topid"];
    [params setObject:@"edb123a494991302d9d9d7a6a31da8ad" forKey:@"showapi_sign"];
    
    
    // 3、发送一个GET请求
    NSURLSessionDataTask *dataTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 数据下载进度
        NSLog(@"%lld",downloadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 获取数据完成
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 获取失败
        NSLog(@"error: %@",error);
        
    }];
    
    // 4、执行请求
    [dataTask resume];
    
}

#pragma mark - POST请求
- (void)afnetworking_POST {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = @"http://route.showapi.com/213-4";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"16246" forKey:@"showapi_appid"];
    [params setObject:@"20160906141407" forKey:@"showapi_timestamp"];
    [params setObject:@"5" forKey:@"topid"];
    [params setObject:@"edb123a494991302d9d9d7a6a31da8ad" forKey:@"showapi_sign"];
    
    NSURLSessionDataTask *dataTask = [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // responseObject 是解析后的对象类型，默认进行了JSON解析
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
    }];
    
    [dataTask resume];
    
}

#pragma mark - 下载数据
- (void)afnetworking_Download {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"https://github.com/fuqinglin/MagicalRecord/archive/master.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 在主线程中更新UI操作(监听下载进度)
        NSLog(@"%lld %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSLog(@"%@",targetPath);
        
        // 将文件从临时URL保存到指定的URL
        NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        docURL = [docURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtURL:targetPath toURL:docURL error:&error];
        if (error) {
            NSLog(@"%@",error);
        } else {
            
            NSLog(@"保存成功");
        }
        
        return docURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"error: %@",error);
        
    }];
    
    [downloadTask resume];
}

#pragma mark - 上传文件
- (void)afnetworking_Upload {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 1、设置响应返回的数据的类型 [AFHTTPResponseSerializer serializer] 表示以NSData类型返回。 默认是 JSON 格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionDataTask *dataTask = [manager POST:@"http://www.chuantu.biz/#upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"image.jpeg"], 1);
        
        // [formData appendPartWithFormData:imageData name:@"imageName"];
        
        // 2、拼接要上传的数据并且设置名称、指明数据的类型(image/jpeg)\(video/mp3)
        [formData appendPartWithFileData:imageData name:@"imageName" fileName:@"image" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%lld %lld",uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *object = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"-----%@",object);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@",error);
        
    }];
    
    [dataTask resume];
}

@end
