


//
//  ChooseAddressListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChooseAddressListViewController.h"
#import "ChooseAddressSearchView.h"
#import "CityPickerVeiw.h"
#import <AMapLocationKit/AMapLocationKit.h>
NSString * UITableViewCellIdentifier = @"UITableViewCellIdentifier";
@interface ChooseAddressListViewController ()<AMapGeoFenceManagerDelegate>
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, copy) NSString *cityName;
 @property(nonatomic, strong) UILabel * emptyLabel;
@end

@implementation ChooseAddressListViewController
- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

- (UILabel *)emptyLabel{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
        _emptyLabel.center = self.view.center;
        _emptyLabel.text = @"暂无数据";
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:15];
        _emptyLabel.textColor = UIColorFromHex(0x242424);
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomerTitle:@"选择地点"];
    [self setupHeaderView];
    [self configGeoFenceManager];
    [self registerCell];
    self.CC_table.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
    self.CC_table.separatorColor = UIColorFromHex(0xE3E3E3);
    self.CC_table.bounces = NO;
}

- (void)registerCell{
    [self.CC_table registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellIdentifier];
}
//初始化地理围栏manager
- (void)configGeoFenceManager {
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //进入，离开，停留都要进行通知
 
}
- (void)setupHeaderView{
    
    ChooseAddressSearchView * searchView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ChooseAddressSearchView class]) owner:nil options:nil].firstObject;
    searchView.tag = 98989893;
   
    [self.view addSubview:searchView];
    searchView.frame = CGRectMake(0, self.CC_table.frame.origin.y-50, self.view.frame.size.width, 50);
    searchView.inputText = ^(NSString *inputText) {
        [self searchInput:inputText];
    };
    searchView.areaBlock = ^{
        [self showCityPicker];
    };
}
-(CGRect)getTableFrame{
    return CGRectMake(0, 64 + 50, kScreenW, kScreenH - 64 - 50);
}

- (void)searchInput:(NSString *)inputText{
    
    [self addGeoFencePOIKeywordRegion:inputText];
    
}


- (void)showCityPicker  {
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] initWithFrame:CGRectZero withType:PickerViewType_city];
    cityView.col = 2;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
          NSArray * array = [value componentsSeparatedByString:@"-"];
        if ([array count]>= 2) {
            NSString * areaStr = array[1];
            self.cityName = areaStr;
            ChooseAddressSearchView * searchView  = [self.view viewWithTag:98989893];
            [searchView setupArea:areaStr];
        }
    }];
}


//添加POI关键词围栏按钮点击
- (void)addGeoFencePOIKeywordRegion:(NSString *)keyword {
    if (!self.cityName||self.cityName.length == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您选择城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self doClear];
    [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:keyword POIType:@"" city:self.cityName  size:20 customID:@"poi_1"];
}
- (void)doClear {
 
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
  
}
//添加地理围栏完成后的回调，成功与失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    
    if ([customID isEqualToString:@"poi_1"]) {
        if (error) {
            NSLog(@"======== poi1 error %@",error);
            self.emptyLabel.hidden = NO;
        } else {
            
            for (AMapGeoFencePOIRegion *region in regions) {
                NSLog(@"==%@==",region.POIItem.name);
                [self.addressArray addObject:region.POIItem.name];
              
            }
            if ([self.addressArray count] >0) {
                [self.CC_table reloadData];
                 self.emptyLabel.hidden = YES;
                
            }else{
                self.emptyLabel.hidden = NO;
                
            }
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 写这个方法防止报警告，只要子类中覆盖这个方法就不会影响显示
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    cell.textLabel.text = self.addressArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ChooseAddressBlock) {
        self.ChooseAddressBlock(self.addressArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
