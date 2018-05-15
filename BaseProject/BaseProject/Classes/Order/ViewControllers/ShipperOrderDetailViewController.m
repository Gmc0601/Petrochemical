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
#import "Masonry.h"
@interface ShipperOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAreaLabel;
@property (weak, nonatomic) IBOutlet UIView *unloadView;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;





@property(nonatomic,strong)WJItemsControlView *topItemsView;
@property (nonatomic,strong) NSArray *carListArray;
@property (nonatomic,strong) NSDictionary *infoDic;

@end

@implementation ShipperOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"订单详情"];

    [self setTopTypeInfo];
    [self requestCarList];
    // Do any additional setup after loading the view from its nib.
}
//头部类型
-(void)setTopTypeInfo{
    //头部控制的segMent
    NSArray *titleArr = @[@"运输信息",@"货源详情"];
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = kScreenW/2.0;
    config.selectedColor = ThemeBlue;
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
            if (!weakSelf.infoDic) {
                [weakSelf requestDetail];
            }
        }
        
        [weakSelf.topItemsView moveToIndex:index];
        [weakSelf.topItemsView endMoveToIndex:index];
        
    }];
    [self.topView addSubview:self.topItemsView];
}

-(void)requestCarList{
    NSString *usertoken = [ConfigModel getStringforKey:UserToken];
    NSDictionary *dic = @{
                          @"userToken":usertoken,
                          @"good_num":self.orderId,
                          };
    
    [HttpRequest postPath:@"_transportation_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *carList = dic[@"info"];
            if ([carList isKindOfClass:[NSArray class]]) {
                self.carListArray = carList;
            }
            
            [self.tableView reloadData];
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
            
        }
    }];
}


-(void)requestDetail{
    NSString *usertoken = [ConfigModel getStringforKey:UserToken];
    NSDictionary *dic = @{
                          @"userToken":usertoken,
                          @"good_num":self.orderId,
                          };
    
    [HttpRequest postPath:@"_user_goodsdetails_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
           NSDictionary *info = dic[@"info"];
            self.infoDic = info;
            [self fillDetail];
            
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
            
        }
    }];
}

-(void)fillDetail{
    
    [self.unloadView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    for (UIView *subView in self.unloadView.subviews) {
        [subView removeFromSuperview];
    }
    self.orderNumberLabel.text = self.infoDic[@"good_num"];
    self.startAreaLabel.text = validString(self.infoDic[@"loading"]);
    self.startAddressLabel.text = validString(self.infoDic[@"loading_address"]);
   
    self.durationLabel.text = validString(self.infoDic[@"mileage"]);
    self.dateLabel.text = validString(self.infoDic[@"use_time"]);
    self.nameLabel.text = validString(self.infoDic[@"type"]);
    self.remarksLabel.text = validString(self.infoDic[@"remark"]);
    
    NSArray *unloadArray = self.infoDic[@"unload"];
    NSArray *unloadAddressArray = self.infoDic[@"unload_address"];
    if ([unloadArray isKindOfClass:[NSArray class]]) {
        for (int i = 0; i<unloadArray.count; i++) {
            UIView *itemView = [[UIView alloc] init];
            [self.unloadView addSubview:itemView];
            itemView.frame = CGRectMake(0, i*50, kScreenW, 50);
            
            UIImageView *iconImageView = [[UIImageView alloc] init];
            iconImageView.image = [UIImage imageNamed:@"weizhi"];
            iconImageView.frame = CGRectMake(12, 18, 11, 13);
            [itemView addSubview:iconImageView];

            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.font = [UIFont systemFontOfSize:15];
            nameLabel.textColor = RGBColor(36, 36, 36);
            nameLabel.text = @"卸货点";
            nameLabel.frame = CGRectMake(31, 0, 82, 50);
             [itemView addSubview:nameLabel];
            
            UILabel *areaLabel = [[UILabel alloc] init];
            areaLabel.font = [UIFont systemFontOfSize:15];
            areaLabel.textColor = RGBColor(36, 36, 36);
            areaLabel.textAlignment = NSTextAlignmentRight;
            areaLabel.text = unloadArray[i];
            areaLabel.frame = CGRectMake(125, 2, kScreenW-125-12, 20);
            [itemView addSubview:areaLabel];
            if ([unloadAddressArray isKindOfClass:[NSArray class]]) {
                if (i<unloadAddressArray.count) {
                    UILabel *addressLabel = [[UILabel alloc] init];
                    addressLabel.font = [UIFont systemFontOfSize:15];
                    addressLabel.textColor = RGBColor(36, 36, 36);
                    addressLabel.textAlignment = NSTextAlignmentRight;
                    addressLabel.frame = CGRectMake(125, 24, kScreenW-125-12, 20);
                    addressLabel.text = unloadAddressArray[i];
                    [itemView addSubview:addressLabel];
                }
            }
            
            UILabel *lineLabel = [[UILabel alloc] init];
            lineLabel.frame = CGRectMake(0, 49, kScreenW, 1);
            lineLabel.backgroundColor = RGBColor(244, 244, 244);
            [itemView addSubview:lineLabel];
        }
        float maxHeight = unloadArray.count*50;
        [self.unloadView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(maxHeight);
        }];
    }
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
    NSDictionary *dataDic = self.carListArray[indexPath.row];
    con.carId = dataDic[@"car_id"];
    con.orderId = self.orderId;
    [self.navigationController pushViewController:con animated:YES];
}

-(void)clickCall:(UIButton *)sender{
    NSDictionary *carDic = self.carListArray[sender.tag];
    NSString *phoneString=[NSString stringWithFormat:@"tel://%@",validString(carDic[@"car_mobile"])];
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
