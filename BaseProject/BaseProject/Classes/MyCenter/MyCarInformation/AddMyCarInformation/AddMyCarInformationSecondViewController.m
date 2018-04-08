//
//  AddMyCarInformationSecondViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddMyCarInformationSecondViewController.h"
#import "CustomSeletedPickView.h"
#import "LeasCustomAlbum.h"
#import "UIImage+MyProperty.h"
#import "MyCarInformationListViewController.h"
#import "NSString+commom.h"

@interface AddMyCarInformationSecondViewController ()

@property (weak, nonatomic) IBOutlet UITextField *carNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxLoadTextField;

@property (weak, nonatomic) IBOutlet UIImageView *drivingLicenceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *otherImageView;

//value
@property (strong, nonatomic) NSMutableDictionary *carTypeValue;
@property (strong, nonatomic) UIImage *drivingLicenceImageValue;
@property (strong, nonatomic) UIImage *otherImageValue;
@end

@implementation AddMyCarInformationSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    if (self.carInfo) {
        __weak typeof(self) weakself = self;
        [self setCustomerTitle:@"修改车辆信息"];
        self.carNumberTextField.text = validString(self.carInfo[@"license"]);
        self.carTypeTextField.text = validString(self.carInfo[@"type"]);
        if ([self.carInfo[@"type"] isEqualToString:@"碳钢罐"]) {
            self.carTypeValue = @{@"type":@"1",@"linkname":@"碳钢罐"}.mutableCopy;
        }else if ([self.carInfo[@"type"] isEqualToString:@"不锈钢罐"]){
            self.carTypeValue = @{@"type":@"2",@"linkname":@"不锈钢罐"}.mutableCopy;
        }else if ([self.carInfo[@"type"] isEqualToString:@"锰钢罐"]){
            self.carTypeValue = @{@"type":@"3",@"linkname":@"锰钢罐"}.mutableCopy;
        }else if ([self.carInfo[@"type"] isEqualToString:@"铝罐"]){
            self.carTypeValue = @{@"type":@"4",@"linkname":@"铝罐"}.mutableCopy;
        }else if ([self.carInfo[@"type"] isEqualToString:@"钢衬塑"]){
            self.carTypeValue = @{@"type":@"5",@"linkname":@"钢衬塑"}.mutableCopy;
        }else{
            self.carTypeValue = @{@"type":@"6",@"linkname":@"塑料罐"}.mutableCopy;
        }
        self.maxLoadTextField.text = validString(self.carInfo[@"load"]);
        [self.drivingLicenceImageView sd_setImageWithURL:[NSURL URLWithString:validString(self.carInfo[@"drive_img"])] placeholderImage:DefaultImage];
        [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:validString(self.carInfo[@"run_img"])] placeholderImage:DefaultImage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            weakself.drivingLicenceImageValue = [NSString stringWithFormat:@"%@",self.carInfo[@"drive_img"]].urlImage;
            weakself.otherImageValue = [NSString stringWithFormat:@"%@",self.carInfo[@"run_img"]].urlImage;
        });
    } else {
        [self setCustomerTitle:@"添加车辆"];
    }
}

#pragma mark -- method

- (IBAction)selectedCarTypeAction:(id)sender {
    //1碳钢罐2不锈钢罐3锰钢罐4铝罐5钢衬塑6塑料罐
    __weak typeof(self) weakself = self;
    NSArray *carType = @[@{@"type":@"1",@"linkname":@"碳钢罐"},
                         @{@"type":@"2",@"linkname":@"不锈钢罐"},
                         @{@"type":@"3",@"linkname":@"锰钢罐"},
                         @{@"type":@"4",@"linkname":@"铝罐"},
                         @{@"type":@"5",@"linkname":@"钢衬塑"},
                         @{@"type":@"6",@"linkname":@"塑料罐"}];
    [CustomSeletedPickView creatCustomSeletedPickViewWithTitle:@"请选择车辆类型" value:carType block:^(NSDictionary *dic) {
        weakself.carTypeValue = dic.mutableCopy;
    }];
}

- (IBAction)addDrivingLicenceImageViewAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageWith:self Value:^(UIImage *images) {
        weakself.drivingLicenceImageValue = images;
    }];
    
}
- (IBAction)addOtherImageViewAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageWith:self Value:^(UIImage *images) {
        weakself.otherImageValue = images;
    }];
}

- (IBAction)updateInfoAction:(id)sender {
    if (self.carNumberTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请填写车牌号码" andView:nil];
        return;
    }
    if (self.carTypeTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请选择车辆类型" andView:nil];
        return;
    }
    if ([validString(self.maxLoadTextField.text) doubleValue] == 0) {
        [ConfigModel mbProgressHUD:@"请填写车辆的载重" andView:nil];
        return;
    }
    if (self.drivingLicenceImageValue == nil) {
        [ConfigModel mbProgressHUD:@"请先添加驾驶证图片" andView:nil];
        return;
    }
    if (self.otherImageValue == nil) {
        [ConfigModel mbProgressHUD:@"请先添加行驶证图片" andView:nil];
        return;
    }
    
    NSDictionary *param = @{}.mutableCopy;
    [param setValue:self.nickNameStr forKey:@"car_name"];
    [param setValue:self.phoneStr forKey:@"car_mobile"];
    [param setValue:self.codeStr forKey:@"code"];
    [param setValue:self.carNumberTextField.text forKey:@"license"];
    [param setValue:[NSString stringWithFormat:@"%@",_carTypeValue[@"type"]] forKey:@"type"];
    [param setValue:self.maxLoadTextField.text forKey:@"load"];
    [param setValue:self.drivingLicenceImageValue.base64String forKey:@"drive_img"];
    [param setValue:self.otherImageValue.base64String forKey:@"run_img"];
    if (self.carInfo) {
        [ConfigModel showHud:self];
        [param setValue:self.carId forKey:@"id"];
        [HttpRequest postPath:@"_amend_usercar_001" params:param resultBlock:^(id responseObject, NSError *error) {
            [ConfigModel hideHud:self];
            NSDictionary *dic = responseObject;
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
                [self CustompopVC];
            }else {
                NSString *errorStr = dic[@"info"];
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    } else {
        [ConfigModel showHud:self];
        [HttpRequest postPath:@"_add_usercar_001" params:param resultBlock:^(id responseObject, NSError *error) {
            [ConfigModel hideHud:self];
            NSDictionary *dic = responseObject;
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                [ConfigModel mbProgressHUD:@"添加成功" andView:nil];
                [self CustompopVC];
            }else {
                NSString *errorStr = dic[@"info"];
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    }
}
- (void) CustompopVC{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[MyCarInformationListViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}
#pragma mark -- setter
- (void) setCarTypeValue:(NSMutableDictionary *)carTypeValue{
    _carTypeValue = carTypeValue;
    NSString *str = [NSString stringWithFormat:@"%@",carTypeValue[@"linkname"]];
    self.carTypeTextField.text = str;
}
- (void) setDrivingLicenceImageValue:(UIImage *)drivingLicenceImageValue{
    _drivingLicenceImageValue = drivingLicenceImageValue;
    self.drivingLicenceImageView.image = drivingLicenceImageValue;
}
- (void) setOtherImageValue:(UIImage *)otherImageValue{
    _otherImageValue = otherImageValue;
    self.otherImageView.image = otherImageValue;
}
@end
