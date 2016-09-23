//
//  ViewController.m
//  地图添加标注视图
//
//  Created by tens04 on 16/9/7.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) void(^geocodeComplatHandle)(NSString *, NSString *);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestAction:)];
    
    [self.mapView addGestureRecognizer:longGest];
    
    self.mapView.showsUserLocation = YES;
    
    if ([CLLocationManager instanceMethodForSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }

}

- (void)longGestAction:(UILongPressGestureRecognizer *)longGest {
    
    // 1、获取触摸点所在地图上的CGPoint坐标
    CGPoint point = [longGest locationInView:self.mapView];
    
    // 2、将地图所在触摸点的坐标 CGPoint 转为对应的经纬度 CLLocationCoordinate2D
    CLLocationCoordinate2D coordinate2D = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    if (longGest.state == UIGestureRecognizerStateBegan) {
        
        // 3、创建并添加一个标注视图到mapView上
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = @"XXXX";
        annotation.coordinate = coordinate2D;
        annotation.subtitle = [NSString stringWithFormat:@"%f, %f",annotation.coordinate.latitude, annotation.coordinate.longitude];
        
        [self setGeocodeComplatHandle:^(NSString *a,NSString *b) {
            
            annotation.title = a;
            annotation.subtitle = b;
        }];
        
        [self geocoder:coordinate2D];
        
        //4、将标注添加到地图上
        [self.mapView addAnnotation:annotation];
    }
    
}

#pragma mark - 地理位置编码
- (void)geocoder:(CLLocationCoordinate2D)coordinate2D {
    
    // 创建一个经纬度位置 CLLocation
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    
    // 1、通过经纬度获取对应的地理位置，查询位置是一个异步操作
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"%@ %@ %@",placemark.name, placemark.thoroughfare,placemark.subThoroughfare);
        
        // 将地理位置名称显示在标注视图上
        if (self.geocodeComplatHandle) {
            
            self.geocodeComplatHandle(placemark.name,placemark.thoroughfare);
        }
    }];
    
    /* 2、通地理位置名称获取对应的经纬度
     [_geocoder geocodeAddressString:@"中国四川省成都市双流区" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
     
     CLPlacemark *placemark = placemarks[0];
     NSLog(@"%f, %f",placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
     }];
     */
}

//在搜索地点标记
- (IBAction)search:(id)sender {
    
    [self.geocoder geocodeAddressString:self.searchText.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = placemarks[0];

        //创建并添加一个标注视图到mapView上
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        
        annotation.coordinate = placemark.location.coordinate;
        
        //将标注添加到地图上
        [self.mapView addAnnotation:annotation];
        
        CLLocationCoordinate2D center = placemark.location.coordinate;
        
        MKCoordinateSpan span = {0.05,0.05};
        
        [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
       
    }];

}


#pragma mark - <MKMapViewDelegate>
// 用户位置发生改变后调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = {0.05,0.05};
    [mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
    }
    
    return _locationManager;
}
@end
