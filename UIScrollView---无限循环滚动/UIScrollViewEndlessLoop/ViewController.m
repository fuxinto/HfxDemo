//
//  ViewController.m
//  UIScrollViewEndlessLoop
//
//  Created by tens04 on 16/8/22.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>


@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (assign, nonatomic) NSInteger centerImageIndex;
@property (strong, nonatomic) UIPageControl *pageControl;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImageData];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self loadImageView];
   
    
}
#pragma mark - 创建视图并定义初始图片
- (void)loadImageView {
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.leftImageView.image = [UIImage imageNamed:self.imageData[self.imageData.count-1]];
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width, 0, Width, Height)];
    self.centerImageView.image = [UIImage imageNamed:self.imageData[0]];

    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width*2, 0, Width, Height)];
    self.rightImageView.image = [UIImage imageNamed:self.imageData[1]];
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    self.centerImageIndex = 0;
    [self.scrollView setContentOffset:CGPointMake(Width, 0) animated:NO];
    
}

- (void)loadImageData {
    // 获取文件的本地路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"imageData" ofType:@"plist"];
    // 将路径转为对应的数据类型(NSArray)
    self.imageData = [NSArray arrayWithContentsOfFile:plistPath];

}
#pragma mark - 偏移后重新加载图片
- (void)loadImage {
    NSInteger leftImageIndex,rightImageIndex;
    CGPoint offset = [self.scrollView contentOffset];
    if (offset.x > Width) {
        //向右偏移 用%可以到图片末尾自动切换到开始
        self.centerImageIndex = (self.centerImageIndex + 1) % self.imageData.count;
    }
    if (offset.x < Width) {
        //向左偏移
        self.centerImageIndex = (self.centerImageIndex +self.imageData.count - 1) % self.imageData.count;
        
    }
    self.centerImageView.image = [UIImage imageNamed:self.imageData[self.centerImageIndex]];
    leftImageIndex = (self.centerImageIndex +self.imageData.count - 1) % self.imageData.count;
    rightImageIndex = (self.centerImageIndex +1) % self.imageData.count;
    
    self.leftImageView.image = [UIImage imageNamed:self.imageData[leftImageIndex]];
    self.rightImageView.image = [UIImage imageNamed:self.imageData[rightImageIndex]];
}

#pragma mark - 停止滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImage];
    [self.scrollView setContentOffset:CGPointMake(Width, 0) animated:NO];
    self.pageControl.currentPage = self.centerImageIndex;

}

#pragma mark - 懒加载视图
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Height - 30, Width, 2)];
        _pageControl.numberOfPages = self.imageData.count;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,Width, Height)];
         _scrollView.contentSize = CGSizeMake(Width*3, Height);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (NSArray *)imageData {
    if (!_imageData) {
        _imageData = [NSArray array];
    }
    return _imageData;
}
@end
