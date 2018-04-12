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
#import "MessageViewController.h"
#import "UIButton+message.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger menuIndex;
    UIButton *messageButton;
}
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSArray *listArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UILabel *noDataLabel;

@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [messageButton updateMessage];
     [self requestList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    menuIndex = 0;
    [self setCustomerTitle:@"货主订单"];
    [self setTopTypeInfo];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kScreenW, kScreenH-108-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150;
    _tableView.estimatedRowHeight = 150;
    _tableView.backgroundColor = RGBColor(227, 227, 227);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self setupRefresh];
    [self setNavInfo];
}

-(void)setNavInfo{
    messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(0, 0, 44, 44);
 
    [messageButton setImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"xinyuandian"] forState:UIControlStateSelected];
    [messageButton addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [messageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)rightBarClick {
    MessageViewController *com = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:com animated:YES];
}

-(void)requestList{
    NSString *usertoken = [ConfigModel getStringforKey:UserToken];
    NSDictionary *dic = @{
                          @"userToken":usertoken,
                          };
    
    [HttpRequest postPath:@"_owner_indent_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
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
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
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
       
        menuIndex = index;
        [weakSelf updateList];
        [weakSelf.topItemsView moveToIndex:index];
        [weakSelf.topItemsView endMoveToIndex:index];
       
    }];
    [self.view addSubview:self.topItemsView];
}

-(void)updateList{
    NSArray *array;
    if (menuIndex==0) {
       array = self.infoDic[@"quanbu"];
    }
    else if (menuIndex==1) {
        array = self.infoDic[@"daizhuanghuo"];
    }
    else if (menuIndex==2) {
        array = self.infoDic[@"yunshuzhong"];
    }
    else if (menuIndex==3) {
        array = self.infoDic[@"jiesu"];
    }
    
    if ([array isKindOfClass:[NSArray class]]) {
        self.listArray = array;
    }
    else{
        self.listArray = nil;
    }
    if (self.listArray.count) {
        self.noDataLabel.hidden = YES;
    }
    else{
        self.noDataLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

-(void)setupRefresh{
    
    WeakSelf(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws initList];
    }];
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        if (ws.listArray.count==ws.page*20) {
//            ws.page = _page+1;
//            [ws initList];
//        }else{
//
//            [ws.tableView.mj_footer endRefreshing];
//        }
//    }];
//     self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)initList{
    _page = 1;
    self.listArray = nil;
    [self.tableView reloadData];
    [self requestList];
    
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
    con.orderId = dataDic[@"good_num"];
    [self.navigationController pushViewController:con animated:YES];
}

-(UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        [self.view addSubview:_noDataLabel];
        _noDataLabel.frame = self.tableView.frame;
        _noDataLabel.text = @"暂无数据";
        _noDataLabel.textColor = RGBColor(81, 81, 81);
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        //_noDataLabel.backgroundColor = [UIColor whiteColor];
    }
    return _noDataLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
