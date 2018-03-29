//
//  CarListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarListViewController.h"
#import "CarCell.h"
#import "CarFooterView.h"
#import "EmptyCarListViewController.h"
#import "ChooseAddressListViewController.h"
#import "CityPickerVeiw.h"
#import "CityNameModel.h" //省市区模型
#import "ZSAnalysisClass.h"  // 数据转模型类

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
NSString * const CarCellIdentifier = @"CarCellIdentifier";
@interface CarListViewController ()<CLLocationManagerDelegate>
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, copy) NSString * carNum;//车牌号
@property(nonatomic, copy) NSString * startLocation;//开始位置
@property(nonatomic, copy) NSString * endLocation;//结束位置
@property(nonatomic, copy) NSString * emptyLocation;//空车位置
@property(nonatomic, copy) NSString * loadingTime;//装车时间
@property(nonatomic, copy) NSString * car_id;//
@property(nonatomic, assign) CGFloat lon;//空车位置经度
@property(nonatomic, assign) CGFloat  lat;//空车位置纬度
@property(nonatomic, copy) NSString * maxLoad;//最大载重
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) NSInteger isOpenLocation;
@end

@implementation CarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self addLeftBarButtonWithImage:[UIImage imageNamed:@"zz"] action:@selector(backAction)];
    [self setCustomerTitle:@"发布车源"];
    [self registerCell];
    self.CC_table.bounces = NO;
    [self setupBottomView];
    self.isOpenLocation = YES;
    [self openLocation];
    
}
- (BOOL)addRefreshHeader{
    return NO;
}
-(CGRect)getTableFrame{
    return CGRectMake(0, 64, kScreenW, kScreenH - 64 - 49);
}
- (UITableViewStyle )getStyle{
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([CarCell class]) bundle:nil] forCellReuseIdentifier:CarCellIdentifier];
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CarFooterView * footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CarFooterView class]) owner:nil options:nil].firstObject;
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 写这个方法防止报警告，只要子类中覆盖这个方法就不会影响显示
    UITableViewCell * cell = nil;
    CarCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CarCellIdentifier];
    
    [self configCell:tempCell withIndexPath:indexPath];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configCell:(CarCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSString * imageName = @"";
    NSString * title = @"";
    NSString * content = @"";
    NSString * placeholder = @"";
    
    switch (indexPath.row ) {
        case 0:{
            title =  @"空车";
            if (self.carNum) {
               content = self.carNum;
            }
            placeholder =  @"请选择空车";
        }
            break;
        case 1:{
            title =  @"起点";
            imageName = @"weizhi";
            if (self.startLocation) {
                content = self.startLocation;
            }
            placeholder =  @"请选择起点";
        }
            break;
        case 2:{
            title =  @"终点";
            imageName = @"weizhi";
            if (self.endLocation) {
                content = self.endLocation;
            }
            placeholder =  @"请选择终点";
        }
            break;
        case 3:{
            title =  @"空车位置";
            if (self.emptyLocation) {
                content = self.emptyLocation;
            }
            placeholder =  @"请选择空城位置";
        }
            break;
        case 4:{
            title =  @"装货时间";
            if (self.loadingTime) {
                content = self.loadingTime;
            }
            placeholder =  @"请选择装车时间";
        }
            break;
        default:
            break;
    }
 
    [cell setupImg:imageName withTitle:title withTextFeild:content withPlaceholder:placeholder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self gotoEmptyCarVC];
    }else if (indexPath.row == 1){
        
        [self getStartLoction];
    } else if (indexPath.row == 2){
        
        [self showCityPicker ];
    }else if (indexPath.row == 3){
        
        [self gotoChooseAddressVC];
    }else if (indexPath.row == 4){
        [self showTimerPicker];
    }
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
- (void)setupBottomView{
    UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:UIColorFromHex(0x028BF3)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString * buttonTitle = @"立即发布";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    [self.view addSubview:self.bottomView];
    [self.bottomView setFrame:CGRectMake(0, CGRectGetMaxY(self.CC_table.frame), kScreenW, 49)];
    [button setFrame:CGRectMake(0, 2, kScreenW, 45)];
    
  
}
- (void)buttonAction:(id)sender{
    [self sendCarInfo];
}


- (void)sendCarInfo{
    
    NSDictionary *dic = @{
                          @"userToken":@"02c8f878c1d5463b5bea89e893cde184",
                          @"car_id":self.car_id,
                          @"origin":self.startLocation,
                          @"destination":self.endLocation,
                          @"empty":self.emptyLocation,
                          @"lon":@(self.lon),
                          @"lat":@(self.lat),
                          @"loading_time":self.loadingTime,
                          @"load":self.maxLoad,
                          @"issue_type":@"1",//发布车源1  发布货源2
                          };
    
    WeakSelf(weakself);
    [HttpRequest postPath:@"_issue_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布车源成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [weakself.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:okAction1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        
    }];
}
- (void)gotoEmptyCarVC{
    EmptyCarListViewController * emptyVC = [[EmptyCarListViewController alloc]init];
    WeakSelf(weakSelf);
    emptyVC.emptyCarBlock = ^(NSDictionary *carInfo) {
        [weakSelf  selectedCar:carInfo];
    };
    [self.navigationController pushViewController:emptyVC animated:YES];
}
- (void)gotoChooseAddressVC{
    ChooseAddressListViewController * chooseAddressVC = [[ChooseAddressListViewController alloc]init];
    [self.navigationController pushViewController:chooseAddressVC animated:YES];
    
}
- (void)selectedCar:(NSDictionary *)carInfo{
    self.carNum = carInfo[@"license"];
    self.car_id = carInfo[@"id"];
    self.maxLoad =  carInfo[@"load"];
    [self.CC_table reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showCityPicker  {
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] initWithFrame:CGRectZero withType:PickerViewType_city];
    cityView.col = 3;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
        self.endLocation = value;
        [self.CC_table reloadData];
    }];
}

- (void)showTimerPicker  {
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] initWithFrame:CGRectZero withType:PickerViewType_timer];
    cityView.col = 3;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
        self.loadingTime = value;
        [self.CC_table reloadData];
    }];
}
- (void)getStartLoction{
    if (self.isOpenLocation) {
        
    }else{
        [self openLocation];
    }
    
}




- (void)openLocation
{
    
    if ([CLLocationManager locationServicesEnabled])  //确定用户的位置服务启用
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        // 2.想用户请求授权(iOS8之后方法)   必须要配置info.plist文件
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 以下方法选择其中一个
            // 请求始终授权   无论app在前台或者后台都会定位
            //  [locationManager requestAlwaysAuthorization];
            // 当app使用期间授权    只有app在前台时候才可以授权
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 距离筛选器   单位:米   100米:用户移动了100米后会调用对应的代理方法didUpdateLocations
        // kCLDistanceFilterNone  使用这个值得话只要用户位置改动就会调用定位
        self.locationManager.distanceFilter = 100.0;
        // 期望精度  单位:米   100米:表示将100米范围内看做一个位置 导航使用kCLLocationAccuracyBestForNavigation
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        // 3.设置代理
        self.locationManager.delegate = self;
        
        // 4.开始定位 (更新位置)
        [self.locationManager startUpdatingLocation];
        
        //        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        // 5.临时开启后台定位  iOS9新增方法  必须要配置info.plist文件 后台定位不然直接崩溃
        //            self.locationManager.allowsBackgroundLocationUpdates = YES;
        //        }
        
        
        NSLog(@"start gps");
        
    }else{
         self.isOpenLocation = NO;
        [self showNoLocationAlert];
        
        
        //        if (IOS8) {
        //            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        //            if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //                [[UIApplication sharedApplication] openURL:url];
        //            }
        //        } else {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        //        }
        
        
    }
}

- (void)showNoLocationAlert{
    
    NSString * title = @"提示";
    NSString * content = @"无法获取您的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许小佳老师使用定位服务。";
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    //    CLLocation *location = newLocation;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f===", coordinate.latitude, coordinate.longitude);
    self.lat =  coordinate.latitude;
    self.lon = coordinate.longitude;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0){
            CLPlacemark * placemark = placemarks[0];
            
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            //            NSString * state =  [placemark.addressDictionary objectForKey:@"State"];
            // 省
            //            NSLog(@"state,%@",state);
            //            // 位置名
            //            NSLog(@"name,%@",placemark.name);
            //            // 街道
            //            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            //            // 子街道
            //            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //            // 市
            //            NSLog(@"locality,%@",placemark.locality);
            //            // 区
            //            NSLog(@"subLocality,%@",placemark.subLocality);
            //            // 国家
            //            NSLog(@"country,%@",placemark.country);
            //            self.cityName = city;
            //            self.provinceName = state;
            
            //            self.subLocality =placemark.subLocality;
            self.startLocation   = placemark.name;
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
            
            
        };
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
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
