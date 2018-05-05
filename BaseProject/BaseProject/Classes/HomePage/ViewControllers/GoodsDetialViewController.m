//
//  GoodsDetialViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsDetialViewController.h"
#import "GoodsDetialviewmodel.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailModel.h"
#import <YYKit.h>
#import "FeailView.h"
#import "RobOrderViewController.h"
#import "MyCarInformationListViewController.h"
#import "MyPublishListViewController.h"
#import "ShipperOrderDetailViewController.h"

@interface GoodsDetialViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *noUseTableView;

@property (nonatomic, strong) NSMutableArray *titleArr, *detialArr;

@property (nonatomic, strong) GoodsDetialviewmodel *viewmodel;

@property (nonatomic, strong) GoodsDetailModel *model;

@property (nonatomic, strong) UIButton *commitBtn, *callBtn;

@property (nonatomic, strong) YYTextView *text;


@end

@implementation GoodsDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setCustomerTitle:@"货源详情"];
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.commitBtn];
    [self.view addSubview:self.callBtn];
    UILabel *line = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, self.callBtn.top, kScreenW/2, 1)];
    line.backgroundColor = RGBColor(230, 240, 241);
    [self.view addSubview:line];
    [self raccomand];
    [HttpRequest postPath:@"_userinfo_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *dic = datadic[@"info"];
            if ([dic[@"approve"] intValue] == 2) {
                //  货主认证
                [ConfigModel saveBoolObject:YES forKey:Shipper_Certification];
                
            }else {
                [ConfigModel saveBoolObject:NO forKey:Shipper_Certification];
                [self.callBtn setTitle:@"平台热线" forState:UIControlStateNormal];
            }
            if ([dic[@"carAuth"] intValue] == 1) {
                //  车主认证
                [ConfigModel saveBoolObject:YES forKey:Car_Certification];
            }else {
                [ConfigModel saveBoolObject:NO forKey:Car_Certification];
            }
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)raccomand {
    [[self.viewmodel.goodDetialCommand execute:@"goodDetial"] subscribeNext:^(GoodsDetailModel * model) {
        self.model = model;
        NSArray *arr = model.xiehuo;
        for (int i = 0; i < arr.count; i++) {
            [self.titleArr insertObject:@"卸货点" atIndex:2];
        }
        NSDictionary *dic = @{@"loading" : self.model.loading,
                              @"loading_address" : self.model.loading_address
                              };
        NSArray *dearr =  @[self.model.good_num, self.model.mileage, self.model.use_time,self.model.type, self.model.weight, self.model.good_price, self.model.cost, self.model.account_type];
        self.detialArr = [[NSMutableArray alloc] initWithArray:dearr];
        [self.detialArr insertObject:dic atIndex:1];
        self.text.text = self.model.remark;
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            NSString *unload = dic[@"unload"];
            NSString *unload_address = dic[@"unload_address"];
            NSDictionary *dicinfo = @{@"unload" : unload, @"unload_address" : unload_address};
            [self.detialArr insertObject:dicinfo atIndex:2+i];
        }
        [self.noUseTableView reloadData];
        
        if (self.type == GoodsDetail) {
            if ([self.model.indent_type intValue] == 1) {
                //  已抢
                self.commitBtn.backgroundColor = [UIColor grayColor];
                self.commitBtn.userInteractionEnabled = NO;
            }
            if ([self.model.user_type intValue] == 1) {
                [self.commitBtn setTitle:@"管理我的货源" forState:UIControlStateNormal];
            }
        }else {
            [self.commitBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        }
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    if ([self.detialArr[indexPath.row] isKindOfClass:[NSString class]]) {
      cell.detailTextLabel.text = self.detialArr[indexPath.row];
    }
    [self updateicon:cell];
    if ([cell.textLabel.text isEqualToString:@"装货点"]) {
        NSDictionary *dic = self.detialArr[indexPath.row];
        NSString *title = dic[@"loading"];
        NSString *sub = dic[@"loading_address"];
        cell.imageView.image = [UIImage imageNamed:@"icon_txddz"];
        [cell.imageView sizeToFit];
        UILabel *titlelab = [[UILabel alloc] initWithFrame:FRAME( 95, 5, kScreenW - 60 - 50, 20)];
        titlelab.font = [UIFont systemFontOfSize:15];
        titlelab.textAlignment = NSTextAlignmentRight;
        titlelab.text = title;
        [cell.contentView addSubview:titlelab];
        UILabel *subLab = [[UILabel alloc] initWithFrame:FRAME(95, 25, kScreenW -60 - 50, 20)];
        subLab.textColor = [UIColor grayColor];
        subLab.font = [UIFont systemFontOfSize:13];
        subLab.textAlignment = NSTextAlignmentRight;
        subLab.text = sub;
        [cell.contentView addSubview:subLab];
        
    }
    if ([cell.textLabel.text isEqualToString:@"卸货点"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_nxddz"];
        [cell.imageView sizeToFit];
        NSDictionary *dic = self.detialArr[indexPath.row];
        NSString *title = dic[@"unload"];
        NSString *sub = dic[@"unload_address"];
        UILabel *titlelab = [[UILabel alloc] initWithFrame:FRAME( 95, 5, kScreenW - 60 - 50, 20)];
        titlelab.font = [UIFont systemFontOfSize:15];
        titlelab.textAlignment = NSTextAlignmentRight;
        titlelab.text = title;
        [cell.contentView addSubview:titlelab];
        UILabel *subLab = [[UILabel alloc] initWithFrame:FRAME(95, 25, kScreenW -60 - 50, 20)];
        subLab.textColor = [UIColor grayColor];
        subLab.font = [UIFont systemFontOfSize:13];
        subLab.textAlignment = NSTextAlignmentRight;
        subLab.text = sub;
        [cell.contentView addSubview:subLab];
    }
    
    
    
    return cell;
    
    
}

- (void)updateicon:(UITableViewCell *)cell {
    NSString *str ;
    
    if ([cell.textLabel.text isEqualToString:@"货单号"]) {
        str = @"danju";
    }
    
    if ([cell.textLabel.text isEqualToString:@"预计里程"]) {
        str = @"btn_time";
    }
    
    if ([cell.textLabel.text isEqualToString:@"用车时间"]) {
        str = @"btn_yongcheshijian";
    }
    
    if ([cell.textLabel.text isEqualToString:@"货物名称"]) {
        str = @"baoguo-1";
    }
    
    if ([cell.textLabel.text isEqualToString:@"货物重量"]) {
        str = @"btn_huowuzhongliang";
    }
    
    if ([cell.textLabel.text isEqualToString:@"运输费"]) {
        str = @"yunshu-feiyong";
    }
    
    if ([cell.textLabel.text isEqualToString:@"运输单价"]) {
        str = @"btn_danjia";
    }
    
    if ([cell.textLabel.text isEqualToString:@"结算方式"]) {
        str = @"btn_jiesuan";
    }
    
    cell.imageView.image = [UIImage imageNamed:str];
    [cell.imageView sizeToFit];
    
//    if ([cell.textLabel.text isEqualToString:@""]) {
//        str = @"";
//    }
//
//    if ([cell.textLabel.text isEqualToString:@""]) {
//        str = @"";
//    }
    
    
    
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50 - [StatusBar floatValue] - [NavbarHeight floatValue]) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UILabel *line = [[UILabel alloc] initWithFrame:FRAME(15, 0, kScreenW , 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
            UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(15, 15, kScreenW , 15)];
            lab.text = @"货主备注";
            [view addSubview:line];
            [view addSubview:lab];
            self.text = [[YYTextView alloc] initWithFrame:FRAME(15, 30, kScreenW - 30, 30)];
            self.text.placeholderText = @"暂无备注";
            self.text.textColor = [UIColor grayColor];
            self.text.font = [UIFont systemFontOfSize:13];
            self.text.userInteractionEnabled = NO;
            [view addSubview:self.text];
            
            //   添加货主备注
            view;
        });
    }
    return _noUseTableView;
}


- (GoodsDetialviewmodel *)viewmodel {
    if (!_viewmodel) {
        _viewmodel =[[GoodsDetialviewmodel alloc] init];
        _viewmodel.id = self.idStr;
    }
    return _viewmodel;
}

- (GoodsDetailModel *)model {
    if (!_model) {
        _model = [[GoodsDetailModel alloc] init];
    }
    return _model;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:FRAME(0, self.noUseTableView.bottom, kScreenW/2, 50)];
        [_commitBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
        _commitBtn.backgroundColor = ThemeBlue;
        [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW/2, self.noUseTableView.bottom, kScreenW/2, 50)];
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _callBtn.backgroundColor = [UIColor blueColor];
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, 0, kScreenW/2, 1)];
        line.backgroundColor = RGBColor(239, 240, 241);
        [_callBtn addSubview:line];
        [_callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

- (void)call {
    NSMutableString* str=[[NSMutableString alloc]initWithFormat:@"telprompt://%@",self.model.hot_line];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}

- (void)commitClick:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"管理我的货源"]) {
        MyPublishListViewController *vc = [[MyPublishListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([sender.titleLabel.text isEqualToString:@"立即抢单"]) {
        
        [HttpRequest postPath:@"_userinfo_001" params:nil resultBlock:^(id responseObject, NSError *error) {
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSDictionary *dic = datadic[@"info"];
                if ([dic[@"approve"] intValue] == 2) {
                    //  货主认证
                    [ConfigModel saveBoolObject:YES forKey:Shipper_Certification];
                }else {
                    [ConfigModel saveBoolObject:NO forKey:Shipper_Certification];
                }
                if ([dic[@"carAuth"] intValue] == 1) {
                    //  车主认证
                    [ConfigModel saveBoolObject:YES forKey:Car_Certification];
                }else {
                    [ConfigModel saveBoolObject:NO forKey:Car_Certification];
                }
                if (![ConfigModel getBoolObjectforKey:Car_Certification]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"完成车辆认证后，才能邀请司机" preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //  跳转到车辆认证
                        MyCarInformationListViewController *vc = [[MyCarInformationListViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    
                    [alert addAction:action1];
                    [alert addAction:action2];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                FeailView *view = [[FeailView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
                view.clickBlick = ^{
                    RobOrderViewController *vc = [[RobOrderViewController alloc] init];
                    vc.good_num = self.model.good_num;
                    vc.balance = self.model.surplus_weight;
                    [self.navigationController pushViewController:vc animated:YES];
                };
                [view pop];
                
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
       
    }
    
    if ([sender.titleLabel.text isEqualToString:@"查看订单"]) {
        ShipperOrderDetailViewController *vc = [[ShipperOrderDetailViewController alloc] init];
        vc.orderId = self.model.good_num;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        NSArray *arr = @[@"货单号",@"装货点", @"预计里程", @"用车时间", @"货物名称", @"货物重量", @"运输单价", @"运输费", @"结算方式"];
        _titleArr = [[NSMutableArray alloc] initWithArray:arr];
    }
    return _titleArr;
}



@end
