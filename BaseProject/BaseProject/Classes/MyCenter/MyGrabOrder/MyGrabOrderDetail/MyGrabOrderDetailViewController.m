//
//  MyGrabOrderDetailViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyGrabOrderDetailViewController.h"
#import "MyPublishCargoDetailXiehuoView.h"

@interface MyGrabOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endViewH;
@property (weak, nonatomic) IBOutlet UILabel *yujichechengLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *good_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *terrace_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTimeLabel;

@property (strong, nonatomic) NSDictionary *dataSource;
@end

@implementation MyGrabOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"抢单详情"];
    [self setupDataSource];
}
- (void) setupDataSource{
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_wxindent_details_001" params:@{@"id":self.orderId} resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            if ([info isKindOfClass:[NSDictionary class]]) {
                self.dataSource = info;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}

- (IBAction)callPhoneAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",validString(self.dataSource[@"car_mobile"])];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void) setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    int indent_status = [validString(dataSource[@"indent_status"]) intValue];
    switch (indent_status) {
        case 1:{
            self.statusImageView.image = [UIImage imageNamed:@"shenhezhonf"];
            self.statusLabel.text = @"认证信息审核中，请耐心等待";
            self.statusLabel.textColor = UIColorFromHex(0x028BF3);
        }
            break;
        case 2:{
            self.statusImageView.image = [UIImage imageNamed:@"tongguo"];
            self.statusLabel.text = @"抢单信息已通过\n请提醒司机登录鲁明危运司机端\n按时完成货物运输";
            self.statusLabel.textColor = UIColorFromHex(0x59B46C);
        }
            break;
        case 3:{
            self.statusImageView.image = [UIImage imageNamed:@"shenheshibai"];
            self.statusLabel.text = validString(dataSource[@"reason"]);
            self.statusLabel.textColor = UIColorFromHex(0x59B46C);
        }
            break;
        default:
            break;
    }
    
    self.nickNameLabel.text = validString(dataSource[@"car_name"]);
    self.loadWeightLabel.text = [NSString stringWithFormat:@"%@吨",dataSource[@"rough_weight"]];
    self.phoneLabel.text = validString(dataSource[@"car_mobile"]);
    self.orderNumberLabel.text = validString(dataSource[@"good_num"]);
    self.loadingLabel.text = validString(dataSource[@"loading"]);
    self.loadAddressLabel.text = validString(dataSource[@"loading_address"]);
    NSString *mileage = validString(dataSource[@"mileage"]);
    NSString *mileageTime = [NSString stringWithFormat:@"%.1f",[mileage doubleValue]/60.0];
    self.yujichechengLabel.text = [NSString stringWithFormat:@"%@公里/%@小时",mileage,mileageTime];
    self.carTimeLabel.text = validString(dataSource[@"use_time"]);
    self.goodsNameLabel.text = validString(dataSource[@"type"]);
    self.goodsWeightLabel.text = [NSString stringWithFormat:@"%@吨",dataSource[@"weight"]];
    self.good_priceLabel.text = [NSString stringWithFormat:@"货主报价: %@/吨",dataSource[@"good_price"]];
    self.terrace_priceLabel.text = [NSString stringWithFormat:@"平台报价: %@/吨",dataSource[@"terrace_price"]];
    self.costLabel.text = [NSString stringWithFormat:@"%@元",dataSource[@"transportation"]];
    self.otherLabel.text = validString(dataSource[@"remark"]);
    self.otherTimeLabel.text = validString(dataSource[@"create_time"]);
    NSArray *unload = dataSource[@"unload"];
    NSArray *unload_address = dataSource[@"unload_address"];
    if ([unload isKindOfClass:[NSArray class]] && [unload_address isKindOfClass:[NSArray class]]) {
        NSInteger temp = unload.count < unload_address.count ?: unload_address.count;
        self.endViewH.constant = temp*54.0;
        for (int index = 0; index < temp; index ++) {
            MyPublishCargoDetailXiehuoView *end = [[NSBundle mainBundle] loadNibNamed:@"MyPublishCargoDetailXiehuoView" owner:self options:nil].firstObject;
            end.frame = CGRectMake(0, index*54, kScreenW, 54);
            //end.dataDic = xiehuo[index];
            end.unload_address.text = validString(unload_address[index]);
            end.unload.text = validString(unload[index]);
            [self.endView addSubview:end];
        }
    }
}
@end
