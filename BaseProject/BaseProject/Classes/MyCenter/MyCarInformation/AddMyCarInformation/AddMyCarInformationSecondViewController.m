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
    [self setCustomerTitle:@"添加车辆"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupAllCarTypeAction];
}

- (void) setupAllCarTypeAction{
    
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
    [LeasCustomAlbum getImageValue:^(UIImage *images) {
        weakself.drivingLicenceImageValue = images;
    }];
    
}
- (IBAction)addOtherImageViewAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageValue:^(UIImage *images) {
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
    if (self.drivingLicenceImageValue == nil) {
        [ConfigModel mbProgressHUD:@"请先添加驾驶证图片" andView:nil];
        return;
    }
    if (self.otherImageValue == nil) {
        [ConfigModel mbProgressHUD:@"请先添加行驶证图片" andView:nil];
        return;
    }
    
    NSDictionary *param = @{}.mutableCopy;
    [param setValue:TokenKey forKey:@"userToken"];
    [param setValue:self.nickNameStr forKey:@"car_name"];
    [param setValue:self.phoneStr forKey:@"car_mobile"];
    [param setValue:self.codeStr forKey:@"code"];
    [param setValue:self.carNumberTextField.text forKey:@"license"];
    [param setValue:[NSString stringWithFormat:@"%@",_carTypeValue[@"type"]] forKey:@"type"];
    [param setValue:self.maxLoadTextField.text forKey:@"load"];
    [param setValue:self.drivingLicenceImageValue.base64String forKey:@"drive_img"];
    [param setValue:self.otherImageValue.base64String forKey:@"run_img"];
    [HttpRequest postPath:@"_add_usercar_001" params:param resultBlock:^(id responseObject, NSError *error) {
        
    }];
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
