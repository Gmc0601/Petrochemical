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


@interface MyPublishCarListViewController ()
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSDictionary *infoDic;
@property (strong, nonatomic)  NSMutableArray *dataSource;
@end

@implementation MyPublishCarListViewController{
    __block NSInteger menuIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"我发布的车源"];
    [self setupUI];
    [self setupDataSource];
}
- (void) setupUI{
    //头部控制的segMent
    NSArray *titleArr = @[@"展示中",@"审核中",@"已失效",@"已拒绝"];
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
        [weakself updateList];
        [weakself.topItemsView moveToIndex:index];
        [weakself.topItemsView endMoveToIndex:index];
        
    }];
    [self.view addSubview:self.topItemsView];
    
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
    [param setValue:TokenKey forKey:@"userToken"];
    [HttpRequest postPath:@"_user_carsource_001" params:param resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *infoDic = dic[@"info"];
            if ([infoDic isKindOfClass:[NSDictionary class]]) {
                self.infoDic = infoDic;
            }
            [self updateList];
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- method
- (void) updateList{
    NSArray *array;
    if (menuIndex==0) {
        array = self.infoDic[@"zhanshi"];
    }
    else if (menuIndex==1) {
        array = self.infoDic[@"shenhe"];
    }
    else if (menuIndex==2) {
        array = self.infoDic[@"shixiao"];
    }
    else if (menuIndex==3) {
        array = self.infoDic[@"jujue"];
    }
    
    if ([array isKindOfClass:[NSArray class]]) {
        self.dataSource = array.mutableCopy;
    }
    else{
        self.dataSource = @[].mutableCopy;
    }
    [self.tableView reloadData];
}


#pragma mark -- method
- (void) rightButtonAction{
    
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
//    cell.dicModel = _dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *data = _dataSource[indexPath.row];
//    MyPublishCargoDetailInfoViewController *detailVC = [MyPublishCargoDetailInfoViewController new];
//    detailVC.infoDic = data;
//    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
