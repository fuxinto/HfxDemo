//
//  ViewController.m
//  NSOperationQueue）
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
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    //[self opration_invocation];
    
    // [self opration_block];
    
    [self oprationQueue];
}



- (void)opration_invocation {
    
    // 直接执行会在主线程中顺序执行
    NSInvocationOperation *opertaion_1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_A) object:nil];
    
    NSInvocationOperation *opertaion_2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_B) object:nil];
    NSInvocationOperation *opertaion_3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_C) object:nil];
    
    // 启动任务
    [opertaion_1 start];
    [opertaion_2 start];
    [opertaion_3 start];
    
}


- (void )opration_block {
    
    // 至少会有一个任务在主线程中执行，其他任务会被放到其他线程中执行
    NSBlockOperation *opertion = [NSBlockOperation blockOperationWithBlock:^{
        
        [self run_A];
    }];
    
    [opertion addExecutionBlock:^{
        
        [self run_B];
    }];
    
    [opertion addExecutionBlock:^{
        
        [self run_C];
    }];
    
    [opertion start];
}


- (void)oprationQueue {
    
    NSInvocationOperation *opertaion_1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_A) object:nil];
    NSInvocationOperation *opertaion_2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_B) object:nil];
    NSInvocationOperation *opertaion_3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run_C) object:nil];
    
    // 添加依赖，opertaion_1 ————》opertaion_2 ————》opertaion_3
    
    //    [opertaion_2 addDependency:opertaion_1];
    //    [opertaion_3 addDependency:opertaion_2];
    
    // 创建一个队列，默认就是并行队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 设置当前最大的执行数，可以控制是并行还串行，为1时就是串行
    queue.maxConcurrentOperationCount = 1;
    
    // 将任务添加到队列中任务就自动执行了
    [queue addOperation:opertaion_1];
    [queue addOperation:opertaion_2];
    [queue addOperation:opertaion_3];
    [queue addOperationWithBlock:^{
        
        [self run_D];
    }];
    
    
    // 添加多个任务，并且可以设置等待完成
    // [queue addOperations:@[opertaion_1,opertaion_2,opertaion_3] waitUntilFinished:YES];
    
    
    // 取消所有的任务
    // [queue cancelAllOperations];
    // 取消指定的任务
    // [opertaion_1 cancel];
    
    // 获取当前的队列
    // [NSOperationQueue currentQueue];
    
    // 获取主队列
    // [NSOperationQueue mainQueue];
    
}


- (void)run_A {
    
    UIImage *image  = [self downloadImage_one];
    
    // 在主线程中执行更新UI
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.imagView_1.image = image;
    }];
    
    
    NSLog(@"A:%@",[NSThread currentThread]);
}

- (void)run_B {
    
    UIImage *image = [self downloadImage_two];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.imageViw_2.image = image;
    }];
    
    NSLog(@"B:%@",[NSThread currentThread]);
}

- (void)run_C {
    
    UIImage *image = [self downloadImage_three];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.imageView_3.image = image;
    }];
    
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
}
@end
