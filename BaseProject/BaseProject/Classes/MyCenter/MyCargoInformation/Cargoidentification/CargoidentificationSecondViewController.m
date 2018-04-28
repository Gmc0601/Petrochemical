//
//  CargoidentificationSecondViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CargoidentificationSecondViewController.h"
#import "CustomSeletedPickView.h"
#import "LeasCustomAlbum.h"
#import "UIImage+MyProperty.h"
#import "NSString+commom.h"
#import "MyCenterViewController.h"

@interface CargoidentificationSecondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *salesmanNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *companyImageView;

@property (strong, nonatomic) NSMutableArray *salemanValues;

@property (strong, nonatomic) NSDictionary *selectedSalemanValue;
@property (strong, nonatomic) UIImage *companyImageValue;
@end

@implementation CargoidentificationSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主认证"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupSalemanDataSource];
    if (self.isRevamp == YES) {
        self.companyNameTextField.text = validString(self.infoDic[@"company_name"]);
        self.companyImageValue = [NSString stringWithFormat:@"%@",self.infoDic[@"hand_img"]].urlImage;
    }
}
- (void) setupSalemanDataSource{
    [HttpRequest postPath:@"_professionallist_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        if ([dic[@"error"] intValue] == 0) {
            self.salemanValues = [dic[@"info"] mutableCopy];
        }else{
            [ConfigModel mbProgressHUD:[NSString stringWithFormat:@"%@",dic[@"info"]] andView:nil];
        }
    }];
}
#pragma mark -- method
- (IBAction)selectedSalemanAction:(id)sender {
    __weak typeof(self) weakself = self;
    [CustomSeletedPickView creatCustomSeletedPickViewWithTitle:@"请选择您的服务专员" value:self.salemanValues block:^(NSDictionary *dic) {
        weakself.selectedSalemanValue = dic;
    }];
}
- (IBAction)selectedCompanyImageViewAction:(id)sender {
    __weak typeof(self) weakseaf = self;
    [LeasCustomAlbum getImageWith:self Value:^(UIImage *images) {
        weakseaf.companyImageValue = images;
    }];
}
- (IBAction)requestAction:(id)sender {
    NSDictionary *param = @{}.mutableCopy;
    [param setValue:UserToken forKey:@"userToken"];
    [param setValue:self.nameStr forKey:@"linkname"];
    [param setValue:self.idCardStr forKey:@"id_num"];
    [param setValue:self.idCardImageStr forKey:@"hand_img"];
    [param setValue:self.companyNameTextField.text forKey:@"company_name"];
    [param setValue:self.companyImageValue.base64String forKey:@"permit"];
    [param setValue:[NSString stringWithFormat:@"%@",self.selectedSalemanValue[@"mobile"]] forKey:@"profession_mobile"];
    if (self.isRevamp == YES) {
        [ConfigModel showHud:self];
        [HttpRequest postPath:@"_save_goods_001" params:param resultBlock:^(id responseObject, NSError *error) {
            [ConfigModel hideHud:self];
            NSDictionary *dic = responseObject;
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                [ConfigModel mbProgressHUD:@"提交成功" andView:nil];
                [self customPopVC];
            }else {
                NSString *errorStr = dic[@"info"];
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    }else{
        [ConfigModel showHud:self];
        [HttpRequest postPath:@"_goods_enter_001" params:param resultBlock:^(id responseObject, NSError *error) {
            [ConfigModel hideHud:self];
            NSDictionary *dic = responseObject;
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                [ConfigModel mbProgressHUD:@"提交成功" andView:nil];
                [self customPopVC];
            }else {
                NSString *errorStr = dic[@"info"];
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    }
}

- (void) customPopVC{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[MyCenterViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}
#pragma mark -- setter
- (void) setCompanyImageValue:(UIImage *)companyImageValue{
    _companyImageValue = companyImageValue;
    self.companyImageView.image = companyImageValue;
}
- (void) setSelectedSalemanValue:(NSDictionary *)selectedSalemanValue{
    _selectedSalemanValue = selectedSalemanValue;
    self.salesmanNameLabel.text = [NSString stringWithFormat:@"%@",selectedSalemanValue[@"linkname"]];
}
@end
