//
//  ViewController.m
//  定位和地图
//
//  Created by tens04 on 16/9/7.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     MKMapTypeStandard = 0, 平面地图
     MKMapTypeSatellite, 卫星地图
     MKMapTypeHybrid, 混合地图
     MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     MKMapTypeHybridFlyover**/
    
    // 设置地图的样式
    self.mapView.mapType = MKMapTypeStandard;
    
    // 是否显示用户位置
    self.mapView.showsUserLocation = YES;
    
    
    /* 授权定位用户的位置，需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
     
     *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
     *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
     
     */
    if ([CLLocationManager instanceMethodForSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        // 定位的精确度
        
        /**
         kCLLocationAccuracyBestForNavigation
         kCLLocationAccuracyBest;
         kCLLocationAccuracyNearestTenMeters;
         kCLLocationAccuracyHundredMeters;
         kCLLocationAccuracyKilometer;
         kCLLocationAccuracyThreeKilometers;
         */
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 多远距离更新位置
        _locationManager.distanceFilter = 10;
    }
    
    return _locationManager;
}


#pragma mark - <MKMapViewDelegate>

// 地图加载完成
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    NSLog(@"%s %f, %f",__func__, mapView.userLocation.coordinate.longitude, mapView.userLocation.coordinate.latitude);
    
//    MKCoordinateSpan span = {0.05,0.05};
//    // 设置地图显示的范围
//    [self.mapView setRegion:MKCoordinateRegionMake(mapView.userLocation.coordinate, span) animated:YES];
//
    
}
// 用户位置更新后调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //设置中心点
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 设置跨度
    MKCoordinateSpan span = {0.05,0.05};
    // 设置地图显示的范围
    [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
}

@end
