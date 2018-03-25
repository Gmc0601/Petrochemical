//
//  CargoidentificationFirstViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CargoidentificationFirstViewController.h"
#import "CargoidentificationSecondViewController.h"
#import "LeasCustomAlbum.h"
#import "UIImage+MyProperty.h"

@interface CargoidentificationFirstViewController ()

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;

@property (strong, nonatomic) UIImage *idCardImageValue;
@end

@implementation CargoidentificationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主认证"];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (IBAction)seletedImageAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageValue:^(UIImage *images) {
        weakself.idCardImageValue = images;
    }];
}

- (IBAction)jumpButtonAction:(id)sender {
    if (self.realNameTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请填写真实姓名" andView:nil];
    }else if (self.idCardTextField.text.length == 0){
        [ConfigModel mbProgressHUD:@"请填写真实的身份证号码" andView:nil];
    }else if (self.idCardImageValue == nil){
        [ConfigModel mbProgressHUD:@"本人手持身份证正面照" andView:nil];
    }else{
        CargoidentificationSecondViewController *secondVC = [CargoidentificationSecondViewController new];
        secondVC.nameStr = self.realNameTextField.text;
        secondVC.idCardStr = self.idCardTextField.text;
        secondVC.idCardImageStr = self.idCardImageValue.base64String;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    
}

- (void) setIdCardImageValue:(UIImage *)idCardImageValue{
    _idCardImageValue = idCardImageValue;
    self.idCardImageView.image = idCardImageValue;
}
@end
