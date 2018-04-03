//
//  MapViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface MapViewController ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, retain)  MAMapView *mapView;

@property (nonatomic, retain) AMapLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"位置"];
    [self addRightBarButtonItemWithTitle:@"导航" action:@selector(right)];
    [AMapServices sharedServices].apiKey = @"c566d3a7bcf00f73ba43f1d82b20b6cf";
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    NSLog(@">>>>%f,%f", [self.latitude floatValue], [self.longitude floatValue]);
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
    [self.mapView addAnnotation:pointAnnotation];
    [self mapViewinit];
}

- (void)right {
    //  跳转高德
    
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    if (!canOpen) {
        [ConfigModel mbProgressHUD:@"请安装高德地图" andView:nil];
        return;
    }
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"鲁明危运",@"",[self.latitude floatValue], [self.longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewinit {
    [AMapServices sharedServices].enableHTTPS = YES;
    
    if (!self.mapView) {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    }
    ///初始化地图
    [self.mapView setZoomLevel:18 animated:YES];
    self.mapView.showsCompass = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate= self;
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 2;
    [self.view addSubview:self.mapView];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
