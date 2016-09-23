//
//  ViewController.m
//  文件管理
//
//  Created by tens04 on 16/8/30.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //沙盒路径目录
    NSString *path = NSHomeDirectory();
    NSLog(@"%@",path);
    //拼接一个目录，会自动加“/”，Documents 目录
    NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
    NSLog(@"%@",docPath);
    
    // 获取Documents目录路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",documents);
    
    //获取Library目录路径
    NSString *library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",library);
    
    //获取缓存目录路径
    NSString *cacher = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",cacher);
    
    //获取Tem目录路径
    NSString *tem = NSTemporaryDirectory();
    NSLog(@"%@",tem);
    
    
    // [self createDirectory];创建目录
    // [self createFile];创建文件并写入数据
    // [self removeFile];根据指定的路径移除文件、目录
    
    //[self moveFile];移动文件

}

#pragma mark - 创建目录
- (void)createDirectory {
    
    // 文件管理类：用于管理（增、删、改、查）沙盒目录文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dataPath = [[self docPath] stringByAppendingPathComponent:@"Datas"];
    
    NSError *error = nil;
    
    // 使用NSFileManager创建目录
    BOOL isCreated = [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    if (isCreated) {
        NSLog(@"创建目录成功");
    } else {
        
        NSLog(@"创建目录失败");
    }
    
    NSLog(@"%@",dataPath);
}

#pragma mark - 创建文件并写入数据
- (void)createFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self docPath] stringByAppendingPathComponent:@"Datas/info.png"];
    
    // NSString *text = @"这是保存的数据";
    // NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *image = [UIImage imageNamed:@"足球"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    // 创建文件
    BOOL isCreated = [fileManager createFileAtPath:filePath contents:imageData attributes:nil];
    if (isCreated) {
        NSLog(@"创建成功");
        
        NSLog(@"%@",[self docPath]);
    } else {
        
        NSLog(@"创建失败");
    }
}

#pragma 根据指导的路径移除文件、目录
- (void)removeFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self docPath] stringByAppendingPathComponent:@"Datas/info.png"];
    
    // 移除文件
    BOOL isRemoved = [fileManager removeItemAtPath:filePath error:nil];
    
    
    if (isRemoved) {
        NSLog(@"文件移除成功");
        
    } else {
        NSLog(@"文件移除失败");
    }
    
    NSLog(@"%@",[self docPath]);
}


#pragma mark - 移动文件
- (void)moveFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self docPath] stringByAppendingPathComponent:@"Datas/info.png"];
    
    NSString *toPath = [[self libPath] stringByAppendingPathComponent:@"足球.png"];
    
    // 移动文件
    BOOL isMoved = [fileManager moveItemAtPath:filePath toPath:toPath error:nil];
    
    if (isMoved) {
        NSLog(@"移动完成");
        NSLog(@"%@",[self docPath]);
    } else {
        
        NSLog(@"移动失败");
    }
}



- (NSString *)libPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)docPath {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




@end
