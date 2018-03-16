//
//  OrderViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "OrderViewController.h"
#import "WJItemsControlView.h"
#import "MJRefresh.h"
#import "ShipperOrderTableViewCell.h"
#import "ShipperOrderDetailViewController.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主订单"];
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"xin"] action:@selector(rightBarClick)];
    self.listArray = [[NSMutableArray alloc] init];
    [self.listArray addObject:@{}];
    [self.listArray addObject:@{}];
    [self setTopTypeInfo];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreenW, kScreenH-108-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(227, 227, 227);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self setupRefresh];
}

- (void)rightBarClick {
    
}


//头部类型
-(void)setTopTypeInfo{
    //头部控制的segMent
    NSArray *titleArr = @[@"全部",@"待装货",@"运输中",@"已完成"];
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = kScreenW/4.0;
    config.selectedColor = UIColorFromHex(0x028BF3);
    config.linePercent = 0.3;
    self.topItemsView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    self.topItemsView.tapAnimation = YES;
    self.topItemsView.config = config;
    self.topItemsView.backgroundColor = [UIColor whiteColor];
    self.topItemsView.titleArray = titleArr;
    
    __typeof (&*self) __weak weakSelf = self;
    
    [self.topItemsView setTapItemWithIndex:^(NSInteger index,BOOL animation){
       
        [weakSelf.topItemsView moveToIndex:index];
        [weakSelf.topItemsView endMoveToIndex:index];
       
    }];
    [self.view addSubview:self.topItemsView];
}

-(void)setupRefresh{
    
    WeakSelf(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws initList];
    }];
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (ws.listArray.count==ws.page*20) {
            ws.page = _page+1;
            [ws initList];
        }else{
           
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
     self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)initList{
    _page = 1;
    self.listArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self requestOrderList];
    
}

-(void)requestOrderList{
    
}
#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellStr = @"ShipperOrderTableViewCell";
    ShipperOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShipperOrderTableViewCell" owner:nil options:nil][0];
    }
    [cell setData:self.listArray[indexPath.row]];
    return cell;
}

#pragma mark--UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShipperOrderDetailViewController *con = [[ShipperOrderDetailViewController alloc] init];
    NSDictionary *dataDic = self.listArray[indexPath.row];
    con.orderId = dataDic[@"id"];
    [self.navigationController pushViewController:con animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
