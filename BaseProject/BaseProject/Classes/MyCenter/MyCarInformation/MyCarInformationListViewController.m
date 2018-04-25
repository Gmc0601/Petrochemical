//
//  MyCarInformationListViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCarInformationListViewController.h"
#import "MyCarInformationTableViewCell.h"
#import "AddMyCarInformationFristViewController.h"
#import "MyCarDetailInfomationViewController.h"
#import "CustomSeletedPickView.h"


@interface MyCarInformationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL isYewu;
@property (strong, nonatomic) NSDictionary *selectedSalemanValue;
@end

@implementation MyCarInformationListViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[].mutableCopy;
    [self setupUI];
    [self jiaoyanYewu];
}

- (void) setupUI{
    [self setCustomerTitle:@"我是车主"];
    self.view.backgroundColor = UIColorFromHex(0xF1F2F2);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = nil;
    
    UIButton *rightButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 44);
        [button setImage:[UIImage imageNamed:@"leastianjia"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void) jiaoyanYewu{
    [HttpRequest postPath:@"_yewu_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        
    }];
}
- (void) setupDataSource{
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_user_car_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *info = dic[@"info"];
            if ([info isKindOfClass:[NSArray class]]) {
                _dataSource = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCarInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarInformationTableViewCellid"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyCarInformationTableViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = _dataSource[indexPath.row];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataSource[indexPath.row];
    MyCarDetailInfomationViewController *detailVC = [MyCarDetailInfomationViewController new];
    detailVC.carId = validString(dic[@"id"]);
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- method
- (void) rightButtonAction{
    if (_isYewu == YES) {
        AddMyCarInformationFristViewController *addCarInfoVC = [AddMyCarInformationFristViewController new];
        [self.navigationController pushViewController:addCarInfoVC animated:YES];
    }else{
        [self addYewuAction];
    }
}
- (void) addYewuAction{
    __weak typeof(self) weakself = self;
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_professionallist_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        if ([dic[@"error"] intValue] == 0) {
            NSArray *info = dic[@"info"];
            if ([info isKindOfClass:[NSArray class]]) {
                [CustomSeletedPickView creatCustomSeletedPickViewWithTitle:@"请选择您的服务专员" value:info block:^(NSDictionary *dic) {
                    weakself.selectedSalemanValue = dic;
                }];
            }
        }else{
            [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"%@",dic[@"info"]] andView:nil];
        }
    }];
}
- (void) setSelectedSalemanValue:(NSDictionary *)selectedSalemanValue{
    _selectedSalemanValue = selectedSalemanValue;
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_addyewu_001" params:@{@"profession_mobile":validString(selectedSalemanValue[@"mobile"])} resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        if ([dic[@"error"] intValue] == 0) {
            _isYewu = YES;
            [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"%@",@"绑定成功"] andView:nil];
        }else{
            [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"%@",dic[@"info"]] andView:nil];
        }
    }];
}
@end
