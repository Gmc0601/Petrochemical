//
//  CargoidentificationProgressViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CargoidentificationProgressViewController.h"
#import "CargoidentificationFirstViewController.h"

@interface CargoidentificationProgressViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (strong, nonatomic) NSMutableDictionary *infoDic;

@end

@implementation CargoidentificationProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主认证审核进度"];
    [self setupDataSource];
}
- (void) setupDataSource{
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_progress_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            if ([info isKindOfClass:[NSDictionary class]]) {
                self.infoDic = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}

- (IBAction)statusButtonAction:(id)sender {
    CargoidentificationFirstViewController *CargoidentificationVC1 = [CargoidentificationFirstViewController new];
    CargoidentificationVC1.isRevamp = YES;
    [self.navigationController pushViewController:CargoidentificationVC1 animated:YES];
}


- (void) setInfoDic:(NSMutableDictionary *)infoDic{
    _infoDic = infoDic;
    int user_status = [validString(infoDic[@"user_status"]) intValue];
    switch (user_status) {
        case 1:{
            self.statusImageView.image = [UIImage imageNamed:@"shenhezhonf"];
            self.statusLabel.text = @"认证信息审核中，请耐心等待";
            self.statusLabel.textColor = UIColorFromHex(0x028BF3);
            self.statusButton.hidden = YES;
        }
            break;
        case 2:{
            self.statusImageView.image = [UIImage imageNamed:@"tongguo"];
            self.statusLabel.text = @"认证信息通过";
            self.statusLabel.textColor = UIColorFromHex(0x028BF3);
            self.statusButton.hidden = YES;
        }
            break;
        case 3:{
            NSString *reason = validString(infoDic[@"reason"]);
            self.statusImageView.image = [UIImage imageNamed:@"shenheshibai"];
            self.statusLabel.text = [NSString stringWithFormat:@"认证失败\n%@",reason];
            self.statusLabel.textColor = UIColorFromHex(0xFF0101);
            self.statusButton.hidden = NO;
        }
            break;
        default:
            break;
    }
}
@end
