//
//  ShipperOrderDetailViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShipperOrderDetailViewController.h"
#import "ShipperOrderDetailCarListTableViewCell.h"
#import "WJItemsControlView.h"
#import "LogisticsDetailsViewController.h"
@interface ShipperOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;





@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (nonatomic,strong) NSMutableArray *carListArray;

@end

@implementation ShipperOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"订单详情"];
    self.carListArray = [[NSMutableArray alloc] init];
    [self.carListArray addObject:@{}];
    [self.carListArray addObject:@{}];
    [self setTopTypeInfo];
    // Do any additional setup after loading the view from its nib.
}


//头部类型
-(void)setTopTypeInfo{
    //头部控制的segMent
    NSArray *titleArr = @[@"运输信息",@"货运详情"];
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = kScreenW/2.0;
    config.selectedColor = UIColorFromHex(0x028BF3);
    config.linePercent = 0.2;
    self.topItemsView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    self.topItemsView.tapAnimation = YES;
    self.topItemsView.config = config;
    self.topItemsView.backgroundColor = [UIColor whiteColor];
    self.topItemsView.titleArray = titleArr;
    
    __typeof (&*self) __weak weakSelf = self;
    
    [self.topItemsView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        if (index==0) {
            weakSelf.tableView.hidden = NO;
            weakSelf.scrollView.hidden = YES;
        }
        else{
            weakSelf.tableView.hidden = YES;
            weakSelf.scrollView.hidden = NO;
        }
        
        [weakSelf.topItemsView moveToIndex:index];
        [weakSelf.topItemsView endMoveToIndex:index];
        
    }];
    [self.topView addSubview:self.topItemsView];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellStr = @"ShipperOrderDetailCarListTableViewCell";
    ShipperOrderDetailCarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShipperOrderDetailCarListTableViewCell" owner:nil options:nil][0];
    }
    cell.callButton.tag = indexPath.row;
    [cell.callButton addTarget:self action:@selector(clickCall:) forControlEvents:UIControlEventTouchUpInside];
    [cell setData:self.carListArray[indexPath.row]];
    return cell;
}

#pragma mark--UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogisticsDetailsViewController *con = [[LogisticsDetailsViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}


-(void)clickCall:(UIButton *)sender{
    NSDictionary *carDic = self.carListArray[sender.tag];
    NSString *phoneString=[NSString stringWithFormat:@"tel://%@",validString(carDic[@"phone"])];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
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
