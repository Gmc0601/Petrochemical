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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewH;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;


//value
@property (strong, nonatomic) NSMutableDictionary *carTypeValue;
@property (strong, nonatomic) UIImage *drivingLicenceImageValue;
@property (strong, nonatomic) UIImage *otherImageValue;
@property (strong, nonatomic) NSMutableArray *carType;

@end

@implementation AddMyCarInformationSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.carType = @[].mutableCopy;
    NSArray *creatCarTypeArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"creatCarTypeArray"];
    if ([creatCarTypeArray isKindOfClass:[NSArray class]]) {
        self.carType = creatCarTypeArray.mutableCopy;
    }
    
    if (self.carInfo) {
        //__weak typeof(self) weakself = self;
        [self setCustomerTitle:@"修改车辆信息"];
        self.nameTextField.text = validString(self.carInfo[@"car_name"]);
        self.carNumberTextField.text = validString(self.carInfo[@"license"]);
        self.carTypeTextField.text = validString(self.carInfo[@"type"]);
        for (NSDictionary *dic in self.carType) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                if ([self.carInfo[@"type"] isEqual:dic[@"linkname"]]) {
                    self.carTypeValue = dic.mutableCopy;
                }
            }
        }
        self.maxLoadTextField.text = validString(self.carInfo[@"load"]);
        [self.drivingLicenceImageView sd_setImageWithURL:[NSURL URLWithString:validString(self.carInfo[@"drive_img"])] placeholderImage:DefaultImage];
        [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:validString(self.carInfo[@"run_img"])] placeholderImage:DefaultImage];
        self.drivingLicenceImageValue = [NSString stringWithFormat:@"%@",self.carInfo[@"drive_img"]].urlImage;
        self.otherImageValue = [NSString stringWithFormat:@"%@",self.carInfo[@"run_img"]].urlImage;
        self.nameViewH.constant = 54;
    } else {
        [self setCustomerTitle:@"添加车辆"];
        self.nameViewH.constant = 0;
    }
}
#pragma mark -- method

- (IBAction)selectedCarTypeAction:(id)sender {
    //1碳钢罐2不锈钢罐3锰钢罐4铝罐5钢衬塑6塑料罐
    __weak typeof(self) weakself = self;
    [CustomSeletedPickView creatCustomSeletedPickViewWithTitle:@"请选择车辆类型" value:self.carType block:^(NSDictionary *dic) {
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
        if (self.nameTextField.text.length == 0) {
            [ConfigModel mbProgressHUD:@"请输入司机姓名" andView:nil];
            return;
        }
        [ConfigModel showHud:self];
        [param setValue:self.carId forKey:@"id"];
        [param setValue:self.nameTextField.text forKey:@"car_name"];
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
