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

@interface MyCarInformationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation MyCarInformationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[].mutableCopy;
    [self setupUI];
    [self setupDataSource];
}

- (void) setupUI{
    [self setCustomerTitle:@"我的车辆"];
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

- (void) setupDataSource{
    [HttpRequest postPath:@"_user_car_001" params:nil resultBlock:^(id responseObject, NSError *error) {
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
    return cell;
}


#pragma mark -- method
- (void) rightButtonAction{
    AddMyCarInformationFristViewController *addCarInfoVC = [AddMyCarInformationFristViewController new];
    [self.navigationController pushViewController:addCarInfoVC animated:YES];
}
@end
