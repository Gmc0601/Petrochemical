//
//  MyPublishCargoDetailInfoViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyPublishCargoDetailInfoViewController.h"
#import "MyPublishCargoDetailXiehuoView.h"
#import "Masonry.h"

@interface MyPublishCargoDetailInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerInfoView;
@property (weak, nonatomic) IBOutlet UILabel *headerInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *good_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *loading_addressLabel;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endViewH;
@property (weak, nonatomic) IBOutlet UILabel *drivingRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *use_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *good_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *terrace_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *account_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (strong, nonatomic) NSMutableDictionary *dataSource;
@end

@implementation MyPublishCargoDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @{}.mutableCopy;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setCustomerTitle:@"货源详情"];
    [self setupDataSource];
}
- (void) setupDataSource{
    [HttpRequest postPath:@"_usergoods_details_001" params:@{@"id":validString(self.infoDic[@"id"])} resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *infoDic = dic[@"info"];
            if ([infoDic isKindOfClass:[NSDictionary class]]) {
                self.dataSource = infoDic.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}

#pragma mark -- setter
- (void) setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    self.good_numLabel.text = validString(dataSource[@"good_num"]);
    self.loadingLabel.text = validString(dataSource[@"loading"]);
    self.loading_addressLabel.text = validString(dataSource[@"loading_address"]);
    self.drivingRangeLabel.text = validString(dataSource[@""]);
    self.use_timeLabel.text = validString(dataSource[@"use_time"]);
    self.typeLabel.text = validString(dataSource[@"type"]);
    self.weightLabel.text = [NSString stringWithFormat:@"%@吨/剩%@吨",validString(dataSource[@"weight"]),validString(dataSource[@"surplus_weight"])];
    self.good_priceLabel.text = [NSString stringWithFormat:@"货主报价：%@/吨",validString(dataSource[@"good_price"])];
    self.terrace_priceLabel.text = [NSString stringWithFormat:@"平台报价：%@/吨",validString(dataSource[@"terrace_price"])];
    self.account_typeLabel.text = validString(dataSource[@"account_type"]);
    self.remarkLabel.text = [NSString
                             stringWithFormat:@"        %@",validString(dataSource[@"remark"])];
    NSArray *xiehuo = dataSource[@"xiehuo"];
    if ([xiehuo isKindOfClass:[NSArray class]]) {
        self.endViewH.constant = xiehuo.count *54;
        for (int index = 0; index < xiehuo.count; index ++) {
            MyPublishCargoDetailXiehuoView *end = [[NSBundle mainBundle] loadNibNamed:@"MyPublishCargoDetailXiehuoView" owner:self options:nil].firstObject;
            end.frame = CGRectMake(0, index*54, kScreenW, 54);
            end.dataDic = xiehuo[index];
            [self.endView addSubview:end];
        }
    }
    
    int good_status = [validString(dataSource[@"good_status"]) intValue];
    switch (good_status) {
        case 0:{
            self.headerInfoLabel.text = @"";
            self.headerInfoView.backgroundColor = [UIColor whiteColor];
            UIButton *leftButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"结束抢单" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x242424) forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                button;
            });
            [self.view addSubview:leftButton];
            [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenW/2));
            }];
            
            UIButton *rightButon = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"查看订单" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                button.backgroundColor = UIColorFromHex(0x028BF3);
                button;
            });
            [self.view addSubview:rightButon];
            [rightButon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenW/2));
            }];
        }
            break;
        case 1:{
            self.headerInfoLabel.text = @"货源信息审核中，请耐心等待...";
            self.headerInfoView.backgroundColor = UIColorFromHex(0x028BF3);
            UIButton *rightButon = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"修改货源信息" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                button.backgroundColor = UIColorFromHex(0x028BF3);
                button;
            });
            [self.view addSubview:rightButon];
            [rightButon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenW));
            }];
        }
            break;
        case 2:{
            self.headerInfoLabel.text = @"该货源已结束抢单";
            self.headerInfoView.backgroundColor = UIColorFromHex(0xFF2D50);
        }
            break;
        case 3:{
            NSString *reason = validString(dataSource[@"reason"]);
            self.headerInfoLabel.text = [NSString stringWithFormat:@"拒绝原因：\n%@",reason];
            self.headerInfoView.backgroundColor = UIColorFromHex(0xFF2D50);
            UIButton *rightButon = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"修改货源信息" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                button.backgroundColor = UIColorFromHex(0x028BF3);
                button;
            });
            [self.view addSubview:rightButon];
            [rightButon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenW));
            }];
        }
            break;
        default:
            break;
    }
}
@end
