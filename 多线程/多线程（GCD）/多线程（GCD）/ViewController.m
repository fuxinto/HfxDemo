//
//  ViewController.m
//  多线程（GCD）
//
//  Created by tens04 on 16/9/3.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    NSThread *thread_D;
}
@property (weak, nonatomic) IBOutlet UIImageView *imagView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViw_2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    // [self GCD_group];
    
    [self GCD_once];
    [self GCD_after];
}

#pragma mark - GCD基本使用
- (void)GCD_test {
    
    // 主队列中不能执行同步操作
    
    /* 1、同步任务：dispatch_sync，会阻塞后面的任务，必需当前任务完成后才能执行下一个
     dispatch_sync(dispatch_get_main_queue(), ^{
     
     self.imagView_1.image = [self downloadImage_one];
     
     });
     */
    
    // 2、异步执行：dispatch_async，不会阻塞后面的任务，任务会马上返回下一个任务不需要等待，当这个任务完成后会通知主线程。
    // dispatch_get_main_queue() 获取主队列，主队列中的任务都会在主线程中执行, 是一个串行队列
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     
     [self run_D];
     });
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     [self run_B];
     });
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     [self run_C];
     });
     */
    
    
    
    // 3、dispatch_get_global_queue() 全局队列，是一个并行队列，可以将队列中的任务放到不同的线程中执行
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_A];
     });
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_B];
     });
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_C];
     });
     */
    
    
    
    // 4、如果在并行队列中同步执行任务，那么这些任务都会在主线程中按顺序执行，也就没有并发性了。
    /*
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_A];
     });
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_B];
     });
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     [self run_C];
     });
     */
    
    
    
    // 5、自定义的串行队列,中异步执行任务，队列会把任务放到一个新的线程中按顺序执行
    
    dispatch_queue_t serialQueue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        
        [self run_A];
    });
    
    dispatch_async(serialQueue, ^{
        
        [self run_B];
    });
    
    dispatch_async(serialQueue, ^{
        
        [self run_C];
    });
    
    
    
    // 6、自定义的并行队列,中异步执行任务，队列会把任务放到不同的线程中执行
    
    /*
     dispatch_queue_t concurrentlQueue = dispatch_queue_create("并行队列", DISPATCH_QUEUE_CONCURRENT);
     dispatch_sync(concurrentlQueue, ^{
     
     [self run_A];
     });
     
     dispatch_sync(concurrentlQueue, ^{
     
     [self run_B];
     });
     
     dispatch_sync(concurrentlQueue, ^{
     
     [self run_C];
     });
     */
}


#pragma mark - CGD_group
- (void)GCD_group {
    
    __block UIImage *image_1;
    __block UIImage *image_2;
    __block UIImage *image_3;
    
    // 1、创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 2、创建队列
    dispatch_queue_t queue = dispatch_queue_create("并行队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 3、在group中异步执行任务
    dispatch_group_async(group, queue, ^{
        
        image_1 = [self downloadImage_one];
    });
    
    dispatch_group_async(group, global, ^{
        
        image_2 = [self downloadImage_two];
    });
    
    dispatch_group_async(group, queue, ^{
        
        image_3 = [self downloadImage_three];
    });
    
    // 4、当group中的任务都执行完后，就会发送一个通知notify调用这个方法
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        self.imagView_1.image = image_1;
        self.imageViw_2.image = image_2;
        self.imageView_3.image = image_3;
        
    });
}

#pragma makr - CGD_once 一次执行
- (void)GCD_once {
    
    // 一次执行，block中的代码只能被执行一次，是线程保护的(同时只能一个线程访问)
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self run_A];
    });
}

#pragma mark - GCD_after 延迟执行
- (void)GCD_after {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self run_B];
    });
}


#pragma mark - 下载、显示图片
- (void)run_A {
    
    NSLog(@"A:%@",[NSThread currentThread]);
    UIImage *image  = [self downloadImage_one];
    
    // 将更新UI的操作放到主队列中
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imagView_1.image = image;
        
    });
    
}


- (void)run_B {
    
    NSLog(@"B:%@",[NSThread currentThread]);
    UIImage *image = [self downloadImage_two];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imageViw_2.image = image;
        
    });
}

- (void)run_C {
    
    NSLog(@"C:%@",[NSThread currentThread]);
    UIImage *image = [self downloadImage_three];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imageView_3.image = image;
        
    });
    
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
}
@end
