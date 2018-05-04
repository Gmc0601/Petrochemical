//
//  MyPublishCarListViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyPublishCarListViewController.h"
#import "WJItemsControlView.h"
#import "MJRefresh.h"
#import "MyPublishCarListTableViewCell.h"
#import "CarsDetialViewController.h"

#import "CarListViewController.h"
#import "TBNavigationController.h"


@interface MyPublishCarListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSDictionary *infoDic;
@property (strong, nonatomic)  NSMutableArray *dataSource;
@end

@implementation MyPublishCarListViewController{
    __block NSInteger menuIndex;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupDataSource];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[].mutableCopy;
    [self setCustomerTitle:@"我发布的车源"];
    [self setupUI];
}
- (void) setupUI{
    //头部控制的segMent
    NSArray *titleArr = @[@"待审核",@"展示中",@"已拒绝",@"已失效"];
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = kScreenW/4.0;
    config.selectedColor = UIColorFromHex(0x028BF3);
    config.linePercent = 0.3;
    self.topItemsView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    self.topItemsView.tapAnimation = YES;
    self.topItemsView.config = config;
    self.topItemsView.backgroundColor = [UIColor whiteColor];
    self.topItemsView.titleArray = titleArr;
    __weak typeof(self) weakself = self;
    [self.topItemsView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        menuIndex = index;
        [weakself setupDataSource];
        [weakself.topItemsView moveToIndex:index];
        [weakself.topItemsView endMoveToIndex:index];
        
    }];
    [self.view addSubview:self.topItemsView];
    WeakSelf(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws setupDataSource];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.tableFooterView = [UIView new];
    
    UIButton *rightButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 44);
        [button setTitle:@"发布" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x242424) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void) setupDataSource{
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:@"1" forKey:@"page"];
    [param setValue:@"2000" forKey:@"size"];
    [param setValue:@(menuIndex+1) forKey:@"status"];
    [HttpRequest postPath:@"_user_carsource_001" params:param resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *info = dic[@"info"];
            if ([info isKindOfClass:[NSArray class]]) {
                self.dataSource = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- method
- (void) rightButtonAction{
    CarListViewController * carListVC = [[CarListViewController alloc]init];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:carListVC];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPublishCarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPublishCarListTableViewCellid"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyPublishCarListTableViewCell" owner:self options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dicModel = _dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarsDetialViewController *VC = [CarsDetialViewController new];
    VC.type = MycarsDetial;
    VC.idStr = validString(_dataSource[indexPath.row][@"id"]);
    [self.navigationController pushViewController:VC animated:YES];
}
@end
