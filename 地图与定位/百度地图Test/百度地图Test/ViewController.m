//
//  ViewController.m
//  百度地图Test
//
//  Created by tens04 on 16/9/8.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件


@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
    float Multiple;
}

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) BMKGeoCodeSearch *search;
@property (strong, nonatomic) BMKLocationService *service;
@property (strong, nonatomic) BMKReverseGeoCodeOption *reverseGeoCode;
@property (nonatomic, strong)UIImageView *photoImageView;
@property (strong, nonatomic) void (^reverseGeocoding)(NSString *);
@property (strong, nonatomic) MBProgressHUD *HUD;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Multiple = 0.01;
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    self.mapView.showMapPoi = YES;
    self.mapView.delegate = self;

    [self.service startUserLocationService];
    UILongPressGestureRecognizer *longReg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotationToMap:)];
    longReg.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longReg];
    
}



#pragma mark - 搜索地址
- (IBAction)searchLocation:(UIButton *)sender {
    
    BMKGeoCodeSearchOption *geoCode = [[BMKGeoCodeSearchOption alloc]init];
    geoCode.address = self.searchText.text;
    
    BOOL  isSuccess = [self.search geoCode:geoCode];
    
    if (isSuccess) {
        NSLog(@"编码发送成功！");
    } else {
        NSLog(@"编码发送失败！");
    }
    
}

//<BMKGeoCodeSearchOption>编码成功后调用的代理方法
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        // 计算两经纬度的直线距离
        CLLocationDistance distance = [self distanceForm:self.service.userLocation.location.coordinate toCoodinate:result.location];

        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
       
        annotation.coordinate = result.location;
        annotation.title = result.address;
        
        annotation.subtitle = [NSString stringWithFormat:@"N:%f E:%f,距离:%.2f KM",result.location.latitude,result.location.longitude, distance / 1000];
        
        [self.mapView addAnnotation:annotation];
        
        CLLocationCoordinate2D center = result.location;
        BMKCoordinateSpan span = {0.01,0.01};
        BMKCoordinateRegion region = {center, span};
        [self.mapView setRegion:region animated:YES];
        
    }
    else {
        [self shwoHUD:@"抱歉，未找到结果"];
    }

}

#pragma mark - 缩小
- (IBAction)shrink:(id)sender {
    
    if (Multiple >= 0.01) {
        Multiple -= 0.03;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
        
        CLLocationCoordinate2D center = coordinate;
        BMKCoordinateSpan span = {Multiple,Multiple};
        BMKCoordinateRegion region = {center, span};
        [self.mapView setRegion:region animated:YES];
    }else {
        [self shwoHUD:@"不能在缩小了"];
    }
    
}

#pragma mark - 放大
- (IBAction)enlarge:(id)sender {
    
    if (Multiple <= 0.1) {
        Multiple += 0.03;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
        
        CLLocationCoordinate2D center = coordinate;
        BMKCoordinateSpan span = {Multiple,Multiple};
        BMKCoordinateRegion region = {center, span};
        [self.mapView setRegion:region animated:YES];
    }else {
        [self shwoHUD:@"不能在放大了"];
    }
}

#pragma mark - MBProgressHUD 提示框
- (void)shwoHUD:(NSString *)message {
    
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.removeFromSuperViewOnHide = YES;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attitude_uncheck"]];
        _HUD.labelText = message;
    }
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:2.0];
    
}

#pragma mark - 显示我的位置
- (IBAction)serviceMe:(UIButton *)sender {
    
    CLLocationCoordinate2D center = self.service.userLocation.location.coordinate;
    BMKCoordinateSpan span = {0.01,0.01};
    BMKCoordinateRegion region = {center, span};
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - 保存截图
- (IBAction)screenshot:(UIButton *)sender {
    UIImage *image = [self.mapView takeSnapshot];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishWithError:contextInfo:), NULL);
    });
    
    
}



- (void)image:(UIImage *)photo didFinishWithError:(NSError *)error contextInfo:(void *)info
{
    if (!error) {
        
        NSLog(@"图片保存成功");
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

#pragma mark - 显示路况
- (IBAction)showTraffic:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.mapView.trafficEnabled = YES;
    } else {
        self.mapView.trafficEnabled = NO;
    }

}
#pragma mark - 添加标注视图
- (void)addAnnotationToMap:(UILongPressGestureRecognizer *)longReg
{
    if (longReg.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [longReg locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        
        
        // 计算两经纬度的直线距离
        CLLocationDistance distance = [self distanceForm:self.service.userLocation.location.coordinate toCoodinate:coordinate];
        
        // 获取地理位置对应的地理名称
        [self reverseGeoCode:coordinate];
        
        __weak typeof(self)weakSelf = self;
        [self setReverseGeocoding:^(NSString *name){
        
            annotation.title = name;
            annotation.subtitle = [NSString stringWithFormat:@"N:%f E:%f,距离:%.2f KM",coordinate.latitude,coordinate.longitude, distance / 1000];
            [weakSelf.mapView addAnnotation:annotation];
        }];
    }
}

- (void)reverseGeoCode:(CLLocationCoordinate2D)coordinate
{

    self.reverseGeoCode.reverseGeoPoint = coordinate;
    BOOL isSuccess = [self.search reverseGeoCode:self.reverseGeoCode];
    if (isSuccess) {
        NSLog(@"反编码发送成功！");
    } else {
        NSLog(@"反编码发送失败！");
    }
}

// <BMKGeoCodeSearchDelegate> 反编码成功后调用的代理方法
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (self.reverseGeocoding) {
        self.reverseGeocoding(result.address);
    }
    
    NSLog(@"--%@ , %@",result.address, result.businessCircle);
}


#pragma mark - 计算两经纬度间的距离
- (CLLocationDistance)distanceForm:(CLLocationCoordinate2D)beigan toCoodinate:(CLLocationCoordinate2D)end
{
    BMKMapPoint pointOne = BMKMapPointForCoordinate(beigan);
    BMKMapPoint pointTwo = BMKMapPointForCoordinate(end);
    return BMKMetersBetweenMapPoints(pointOne, pointTwo);
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    
    self.mapView.delegate = self;
    NSLog(@"视图加载成功");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    
    self.mapView.delegate = nil;
    self.service.delegate = nil;
}
- (BMKLocationService *)service {
    
    if (!_service) {
        _service = [[BMKLocationService alloc]init];
        _service.distanceFilter = 10;
        _service.desiredAccuracy = kCLLocationAccuracyBest;
        _service.delegate = self;
    }
    return _service;
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


- (BMKGeoCodeSearch *)search {
    if (!_search) {
        _search = [[BMKGeoCodeSearch alloc]init];
        _search.delegate = self;
    }
    return _search;
}
- (BMKReverseGeoCodeOption *)reverseGeoCode {
    if (!_reverseGeoCode) {
        _reverseGeoCode = [[BMKReverseGeoCodeOption alloc]init];
    }
    return _reverseGeoCode;
}

#pragma mark - <BMKMapViewDelegate>
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    NSLog(@"地图加载完成！");
}


#pragma mark - <BMKLocationServiceDelegate>

- (void)willStartLocatingUser
{
    NSLog(@"开始定位！");
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"定位成功！");
    
    [self.mapView updateLocationData:userLocation];
    [self serviceMe:nil];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位出错：%@",error);
}

@end
