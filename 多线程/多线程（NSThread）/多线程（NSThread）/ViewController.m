//
//  ViewController.m
//  多线程（NSThread）
//
//  Created by tens04 on 16/9/3.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSThread *thread_D;
}

@property (weak, nonatomic) IBOutlet UIImageView *imagView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViw_2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---- %@",[NSThread currentThread]);
    
    //    [self run_A];
    //    [self run_B];
    //    [self run_C];
    //    [self run_D];
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    // 1、创建线程、执行下载任务，需要start手动开启执行
    NSThread *thread_A = [[NSThread alloc] initWithTarget:self selector:@selector(run_A) object:nil];
    thread_A.name = @"线程A";
    
    NSThread *thread_B = [[NSThread alloc] initWithTarget:self selector:@selector(run_B) object:nil];
    thread_B.name = @"线程B";
    NSThread *thread_C = [[NSThread alloc] initWithTarget:self selector:@selector(run_C) object:nil];
    thread_C.name = @"线程C";
    thread_D = [[NSThread alloc] initWithTarget:self selector:@selector(run_D) object:nil];
    thread_D.name = @"线程D";
    
    [thread_A start];
    [thread_B start];
    [thread_C start];
    [thread_D start];
    
    // 阻塞线程，等待几秒
    // [NSThread sleepForTimeInterval:5];
    
    // 阻塞到某个时间
    // [NSThread sleepUntilDate:[[NSDate date] dateByAddingTimeInterval:1000]];
    
    
    // 2、方式二：指定任务直接执行不需要手动开启 start
    //    [NSThread detachNewThreadSelector:@selector(run_A) toTarget:self withObject:nil];
    //    [NSThread detachNewThreadSelector:@selector(run_B) toTarget:self withObject:nil];
    //    [NSThread detachNewThreadSelector:@selector(run_C) toTarget:self withObject:nil];
    //    [NSThread detachNewThreadSelector:@selector(run_D) toTarget:self withObject:nil];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 取消进程
    [thread_D cancel];
}


- (void)run_A {
    
    UIImage *image  = [self downloadImage_one];
    
    // 下载完后在主线程MainThread 中更新UI
    [self.imagView_1 performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
    NSLog(@"A:%@",[NSThread currentThread]);
}

- (void)run_B {
    
    UIImage *image = [self downloadImage_two];
    [self.imageViw_2 performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    NSLog(@"B:%@",[NSThread currentThread]);
}

- (void)run_C {
    
    UIImage *image = [self downloadImage_three];
    [self.imageView_3 performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
    NSLog(@"C:%@",[NSThread currentThread]);
    
}

- (void)run_D {
    
    [self download_music];
    NSLog(@"D:%@",[NSThread currentThread]);
}



#pragma mark - 网络获取图片数据
- (UIImage *)downloadImage_one {
    
    NSURL *imageURL_01 = [NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv-001.jpg"];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL_01];
    return [UIImage imageWithData:data];
}

- (UIImage *)downloadImage_two {
    
    NSURL *imageURL_01 = [NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv-002.jpg"];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL_01];
    return [UIImage imageWithData:data];
}

- (UIImage *)downloadImage_three {
    
    NSURL *imageURL_01 = [NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201507/01/yindian_meinv.jpg"];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL_01];
    return [UIImage imageWithData:data];
}

// 下载音乐数据
- (void)download_music {
    
    NSURL *musicURL = [NSURL URLWithString:@"http://dl.stream.qqmusic.qq.com/108237667.mp3?vkey=AEB0A1FDD35CD8A7A2571E5369512D2419949D55680265CB93C418C109791948FB2AE299C1E4EA9F7A1936427DD82436F0A50BA994D316A0&guid=2718671044"];
    NSData *data =  [NSData dataWithContentsOfURL:musicURL];
}@end
