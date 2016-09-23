//
//  ViewController.m
//  04-百度地图BMKMapView使用
//
//  Created by qinglinfu on 16/3/7.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
}

@property (nonatomic, strong)IBOutlet BMKMapView *myMapView;
@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)BMKGeoCodeSearch *codeSearch;
@property (nonatomic, strong)UIImageView *photoImageView;

@property (nonatomic, copy)void (^reverseGeoCodeComplet)(NSString *address);


@end

@implementation ViewController

- (void)setMapView
{
    if (_myMapView) {
        
        _myMapView.mapType = BMKMapTypeStandard;
        _myMapView.showsUserLocation = YES;
        _myMapView.userTrackingMode = BMKUserTrackingModeNone;
        _myMapView.showMapPoi = YES;
        _myMapView.delegate = self;
        
        [self.locationService startUserLocationService];
        
        UILongPressGestureRecognizer *longReg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotationToMap:)];
        longReg.minimumPressDuration = 0.5;
        [self.view addGestureRecognizer:longReg];
    }
}

- (BMKLocationService *)locationService
{
    if (!_locationService) {
        
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 10;
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        _locationService.delegate = self;
    }
    
    return _locationService;
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        
        _photoImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _photoImageView.layer.borderWidth = 10;
        
        [self.view addSubview:_photoImageView];
    }
    return _photoImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMapView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [_myMapView viewWillAppear];
    self.myMapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_myMapView viewWillDisappear];
    
    self.myMapView.delegate = nil;
}

// 显示用户位置
- (IBAction)localUser:(UIButton *)sender {
    
    CLLocationCoordinate2D center = self.locationService.userLocation.location.coordinate;
    BMKCoordinateSpan span = {0.01,0.01};
    BMKCoordinateRegion region = {center, span};
    [self.myMapView setRegion:region animated:YES];
}

// 显示路况
- (IBAction)showCarLine:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.myMapView.trafficEnabled = YES;
    } else {
        self.myMapView.trafficEnabled = NO;
    }
}

// 截屏并保存到相册中
- (IBAction)mapPhoto:(UIButton *)sender {
    
    UIImage *image = [self.myMapView takeSnapshot];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishWithError:contextInfo:), NULL);
    });
    
    
}

- (void)image:(UIImage *)photo didFinishWithError:(NSError *)error contextInfo:(void *)info
{
    if (!error) {
        
        NSLog(@"图片保存成功！");
        self.photoImageView.hidden = NO;
        self.photoImageView.image = photo;
        [UIView animateWithDuration:1.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{
            

            self.photoImageView.transform = CGAffineTransformMakeTranslation(-100, self.view.bounds.size.height);
        
        } completion:^(BOOL finished) {
            
            self.photoImageView.hidden = YES;
            self.photoImageView.transform = CGAffineTransformIdentity;
            
        }];
        
    }
}


#pragma mark - 添加标注视图
- (void)addAnnotationToMap:(UILongPressGestureRecognizer *)longReg
{
    if (longReg.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [longReg locationInView:self.myMapView];
        CLLocationCoordinate2D coordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        
        
        // 计算两经纬度的直线距离
        CLLocationDistance distance = [self distanceForm:self.locationService.userLocation.location.coordinate toCoodinate:coordinate];
        
        // 获取地理位置对应的地理名称
        [self reverseGeoCode:coordinate];
        
        __weak typeof(self)weakSelf = self;
        [self setReverseGeoCodeComplet:^(NSString *address) {
           
            annotation.title = address;
            annotation.subtitle = [NSString stringWithFormat:@"N:%f E:%f,距离:%.2f KM",coordinate.latitude,coordinate.longitude, distance / 1000];
            [weakSelf.myMapView addAnnotation:annotation];
        }];
    }
}

#pragma mark - 计算两经纬度间的距离
- (CLLocationDistance)distanceForm:(CLLocationCoordinate2D)beigan toCoodinate:(CLLocationCoordinate2D)end
{
    BMKMapPoint pointOne = BMKMapPointForCoordinate(beigan);
    BMKMapPoint pointTwo = BMKMapPointForCoordinate(end);
    return BMKMetersBetweenMapPoints(pointOne, pointTwo);
}

#pragma mark - 地理位置反编码获取地理名称
- (BMKGeoCodeSearch *)codeSearch
{
    if (!_codeSearch) {
        
        _codeSearch = [[BMKGeoCodeSearch alloc] init];
        _codeSearch.delegate = self;
    }
    return _codeSearch;
}

- (void)reverseGeoCode:(CLLocationCoordinate2D)coordinate
{
    if (!_reverseGeoCodeOption) {
         _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    }
   
    _reverseGeoCodeOption.reverseGeoPoint = coordinate;
    BOOL isSuccess = [self.codeSearch reverseGeoCode:_reverseGeoCodeOption];
    if (isSuccess) {
        NSLog(@"反编码发送成功！");
    } else {
        NSLog(@"反编码发送失败！");
    }
}

// <BMKGeoCodeSearchDelegate> 反编码成功后调用的代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (self.reverseGeoCodeComplet) {
        _reverseGeoCodeComplet(result.address);
    }
    
    NSLog(@"--%@ , %@",result.address, result.businessCircle);
}



#pragma mark - <BMKMapViewDelegate>
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"地图加载完成！");
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    static NSString *indentify = @"newAnnotation";
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:indentify];
    if (!annotationView) {
        
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indentify];
        annotationView.image = [UIImage imageNamed:@"标注"];
        
        annotationView.canShowCallout = YES;
        
        annotationView.centerOffset = CGPointMake(0, -25);
        
        annotationView.enabled3D = YES;
        
        annotationView.draggable = YES;
    }
    
    return annotationView;
}


#pragma mark - <BMKLocationServiceDelegate>

- (void)willStartLocatingUser
{
    NSLog(@"开始定位！");
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"定位成功！");
    
    [self.myMapView updateLocationData:userLocation];
    
    [self localUser:nil];

}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位出错：%@",error);
}
@end
