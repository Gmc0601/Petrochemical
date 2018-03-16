//
//  InformationViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "InformationViewController.h"
#import "WJItemsControlView.h"
#import "MJRefresh.h"
#import "InformationVideoTableViewCell.h"
#import "InformationImageTableViewCell.h"
#import "InformationDetailViewController.h"

@interface InformationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"咨询"];
    
    self.listArray = @[@{@"type":@"0",@"name":@"xxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxyxxy"},@{@"type":@"1",@"name":@"xxyxxy"}].mutableCopy;
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"xin"] action:@selector(rightBarClick)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(227, 227, 227);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

- (void)rightBarClick {
    
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
    
    NSDictionary *dataDic = [self.listArray objectAtIndex:indexPath.row];
    NSInteger type = [dataDic[@"type"] integerValue];
    if (type==0) {
        NSString *cellStr = @"InformationImageTableViewCell";
        InformationImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InformationImageTableViewCell" owner:nil options:nil][0];
        }
        [cell setData:self.listArray[indexPath.row]];
        return cell;
    }
    else{
        NSString *cellStr = @"InformationVideoTableViewCell";
        InformationVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"InformationVideoTableViewCell" owner:nil options:nil][0];
        }
        [cell setData:self.listArray[indexPath.row]];
        return cell;
    }

}

#pragma mark--UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationDetailViewController *con = [[InformationDetailViewController alloc] init];
  //  NSDictionary *dataDic = self.listArray[indexPath.row];
  //  con.orderId = dataDic[@"id"];
    [self.navigationController pushViewController:con animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
