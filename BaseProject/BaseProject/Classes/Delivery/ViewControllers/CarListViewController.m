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

#import "CityPickerVeiw.h"
#import "CityNameModel.h" //省市区模型
#import "ZSAnalysisClass.h"  // 数据转模型类
NSString * const CarCellIdentifier = @"CarCellIdentifier";
@interface CarListViewController ()
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, copy) NSString * carNum;//车牌号
@property(nonatomic, copy) NSString * startLocation;//开始位置
@property(nonatomic, copy) NSString * endLocation;//结束位置
@property(nonatomic, copy) NSString * emptyLocation;//空车位置
@property(nonatomic, copy) NSString * loadingTime;//装车时间
@property(nonatomic, copy) NSString * car_id;//
@property(nonatomic, copy) NSString * lon;//空车位置经度
@property(nonatomic, copy) NSString * lat;//空车位置纬度
@property(nonatomic, copy) NSString * maxLoad;//最大载重
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
    }else if (indexPath.row == 2){
        
        [self showCityPicker ];
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
                          @"userToken":@"e56d19bd376625cc2bc7aa6ae40e385a",
                          @"car_id":self.car_id,
                          @"origin":self.startLocation,
                          @"destination":self.endLocation,
                          @"empty":self.emptyLocation,
                          @"lon":self.lon,
                          @"lat":self.lat,
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
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] init];
    cityView.col = 3;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
        self.endLocation = value;
        [self.CC_table reloadData];
    }];
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
