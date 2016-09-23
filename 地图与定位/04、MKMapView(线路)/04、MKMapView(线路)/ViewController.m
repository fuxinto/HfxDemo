//
//  ViewController.m
//  02、MKMapView添加标注视图
//
//  Created by kinglinfu on 16/9/7.
//  Copyright © 2016年 tens. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate> {
    
    CLLocationCoordinate2D _coordinates[10];
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) void(^geocodeComplatHandle)(NSString *name);

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
    
    static int index = 0;
    
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
    
        [self setGeocodeComplatHandle:^(NSString *locationName) {
            
            annotation.title = locationName;
        }];
        
        [self geocoder:coordinate2D];
        
        //4、将标注添加到地图上
        [self.mapView addAnnotation:annotation];
        
        
        _coordinates[index] = coordinate2D;
        index++;
        
        if (index == 1) {
            
            // 创建一个连接多个经纬度的线条
            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:_coordinates count:5];
             [self.mapView addOverlay:polyline];
            
            // 创建一个圆形覆盖物
            //MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate2D radius:1000];
            //[self.mapView addOverlay:circle];
            
            // MKShape
            
            index = 0;
        }
        
    }
}



#pragma mark - 地理位置编码
- (void)geocoder:(CLLocationCoordinate2D)coordinate2D {
    
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    // 创建一个经纬度位置 CLLocation
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    
    // 1、通过经纬度获取对应的地理位置，查询位置是一个异步操作
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSLog(@"%@ %@ %@",placemark.name, placemark.thoroughfare,placemark.subThoroughfare);
        
        // 将地理位置名称显示在标注视图上
        if (self.geocodeComplatHandle) {
            
            self.geocodeComplatHandle(placemark.name);
        }
    }];
    
}


- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
    }
    
    return _locationManager;
}


#pragma mark - <MKMapViewDelegate>
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = {0.05,0.05};
    [mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
}

// 绘制覆盖物，只要添加了 addOverlay 这个协议都会调用
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    // 绘制线条
    MKPolylineRenderer *line = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    line.lineWidth = 3;
    line.strokeColor = [UIColor redColor];
    
    return line;
    
    // 绘制圆形
    /*
    MKCircleRenderer *view = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    
    view.fillColor = [UIColor colorWithWhite:0 alpha:0.5];
    return view;
     
     */
    
}


@end
