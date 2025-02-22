//
//  CarsDetialViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarsDetialViewController.h"
#import "CarDetialviewmodel.h"
#import "CarDetailModel.h"
#import <YYKit.h>
#import "MapViewController.h"
#import "MyPublishCarListViewController.h"
#import "CargoidentificationFirstViewController.h"

@interface CarsDetialViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *noUseTableView;

@property (nonatomic, strong) CarDetialviewmodel *viewmodel;

@property (nonatomic, strong) CarDetailModel *model;

@property (nonatomic, strong) NSArray *titleArr, *detailArr, *iconArr;

@property (nonatomic, strong) UIButton *commitBtn, *callBtn;

@end

@implementation CarsDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout=UIRectEdgeNone;
    [self navitation];
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.commitBtn];
    [self.view addSubview:self.callBtn];
//    UILabel *line = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, self.callBtn.top, kScreenW/2, 1)];
//    line.backgroundColor = RGBColor(230, 240, 241);
//    [self.view addSubview:line];
    [self raccommad];
    [HttpRequest postPath:@"_userinfo_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *dic = datadic[@"info"];
            if ([dic[@"approve"] intValue] == 2) {
                //  货主认证
                [ConfigModel saveBoolObject:YES forKey:Shipper_Certification];
                [self.callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
            }else {
                [ConfigModel saveBoolObject:NO forKey:Shipper_Certification];
                [self.callBtn setTitle:@"平台热线" forState:UIControlStateNormal];
            }
            if ([dic[@"carAuth"] intValue] == 1) {
                //  车主认证
                [ConfigModel saveBoolObject:YES forKey:Car_Certification];
                [self.callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
            }else {
                [ConfigModel saveBoolObject:NO forKey:Car_Certification];
                [self.callBtn setTitle:@"平台热线" forState:UIControlStateNormal];
            }
            
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)raccommad {
    [[self.viewmodel.carDetialCommand execute:@"cardetial"] subscribeNext:^(CarDetailModel * model) {
        self.model = model;
        self.detailArr = @[self.model.linkname,
                           self.model.license,
                           self.model.origin,
                           self.model.destination,
                           self.model.empty,
                           self.model.loading_time,
                           self.model.type,
                           self.model.load];
        [self.noUseTableView reloadData];
        if (self.type == CarsDetail) {
            if ([model.status intValue] == 1) {
                [self.commitBtn setTitle:@"已发出邀请，请等待" forState:UIControlStateNormal];
                self.commitBtn.backgroundColor = UIColorFromHex(0xcccccc);
                self.commitBtn.userInteractionEnabled =  NO;
            }
            if ([model.uid isEqualToString:@"11"]) {
                [self.commitBtn setTitle:@"管理我的车队" forState:UIControlStateNormal];
            }
        }else {
            [self.commitBtn setTitle:@"删除" forState:UIControlStateNormal];
        }
       
    }];
}

- (void)navitation {
    if (self.type == CarsDetail) {
        [self setCustomerTitle:@"车源详情"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.detailTextLabel.text = self.detailArr[indexPath.row];
    
//    if ([cell.textLabel.text isEqualToString:@"起点"] || [cell.textLabel.text isEqualToString:@"终点"]) {
        NSString *imagestr = self.iconArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imagestr];
        [cell.imageView sizeToFit];
//    }
    
    if ([cell.textLabel.text isEqualToString:@"空车位置"] ) {
        cell.detailTextLabel.textColor = ThemeBlue;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weizhi"]];
        cell.accessoryView = imageView;
    }
    return cell;
    
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.noUseTableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"空车位置"]) {
        MapViewController *vc = [[MapViewController alloc] init];
        vc.latitude = self.model.lat;
        vc.longitude = self.model.lon;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
    }
    return _noUseTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CarDetialviewmodel *)viewmodel {
    if (!_viewmodel) {
        _viewmodel  = [[CarDetialviewmodel alloc] init];
        _viewmodel.id = self.idStr;
    }
    return _viewmodel;
}

- (CarDetailModel *)model {
    if (!_model) {
        _model = [[CarDetailModel alloc] init];
    }
    return _model;
}

- (NSArray *)iconArr {
    if (!_iconArr) {
        _iconArr = @[@"sijixingming",@"cheyuan-chepai", @"icon_nxddz",@"icon_txddz", @"cheyuan_kongcheweizhi", @"cheyuan-zhuanghuoshijian", @"guanticaizhi", @"zaizhong"];
    }
    return _iconArr;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"司机姓名", @"车牌号", @"起点",@"终点", @"空车位置", @"装货时间", @"罐体材质", @"最大载重"];
    }
    return _titleArr;
}

- (void)commitClick:(UIButton *)sender {
    
    
    
    if ([sender.titleLabel.text isEqualToString:@"立即邀请"]) {
        
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
                
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
        if (![ConfigModel getBoolObjectforKey:Shipper_Certification]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"完成货主认证后,才能邀请司机" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //  跳转到货主认证
                CargoidentificationFirstViewController *vc = [[CargoidentificationFirstViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        NSDictionary *dic = @{@"id": self.idStr};
        [HttpRequest postPath:@"_invite_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                [ConfigModel mbProgressHUD:@"邀请成功" andView:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
    }
    if ([sender.titleLabel.text isEqualToString:@"管理我的车队"]) {
        //  管理我的车队
        MyPublishCarListViewController *vc = [[MyPublishCarListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:FRAME(0, self.noUseTableView.bottom, kScreenW/2, 50)];
        [_commitBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
        _commitBtn.backgroundColor = ThemeBlue;
        [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW/2, self.noUseTableView.bottom, kScreenW/2, 50)];
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _callBtn.backgroundColor = UIColorHex(0x2683f5);
        [_callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

- (void)call {
    NSMutableString* str=[[NSMutableString alloc]initWithFormat:@"telprompt://%@",self.model.hot_line];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}


@end
