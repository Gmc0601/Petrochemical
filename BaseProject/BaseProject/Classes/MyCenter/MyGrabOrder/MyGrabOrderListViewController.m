//
//  MyGrabOrderListViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyGrabOrderListViewController.h"
#import "WJItemsControlView.h"
#import "MyGrabOrderListTableViewCell.h"
#import "MJRefresh.h"
#import "MyPublishCargoDetailInfoViewController.h"

@interface MyGrabOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@property (strong, nonatomic)  NSMutableArray *dataSource;

@end

@implementation MyGrabOrderListViewController{
    __block NSInteger menuIndex;
    NSString *_searchStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"我的抢单"];
    menuIndex = 0;
    [self setupUI];
    [self setupDataSource];
}

- (void) setupUI{
    //头部控制的segMent
    NSArray *titleArr = @[@"审核中",@"已通过",@"已拒绝"];
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = kScreenW/3.0;
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
}

- (void) setupDataSource{
    NSMutableDictionary *param = @{}.mutableCopy;
//    [param setValue:TokenKey forKey:@"userToken"];
    [param setValue:@"1" forKey:@"page"];
    [param setValue:@"2000" forKey:@"size"];
    [param setValue:_searchStr forKey:@"content"];
    [param setValue:@(menuIndex+1) forKey:@"status"];
    [HttpRequest postPath:@"_user_goods_001" params:param resultBlock:^(id responseObject, NSError *error) {
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
- (IBAction)searchButtonAction:(id)sender {
    _searchStr = self.searchTextField.text;
    [self setupDataSource];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGrabOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGrabOrderListTableViewCellid"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyGrabOrderListTableViewCell" owner:self options:nil].firstObject;
    }
    cell.dic = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
