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
#import "NSString+commom.h"


@interface CargoidentificationFirstViewController ()

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;

@property (strong, nonatomic) UIImage *idCardImageValue;
@property (strong, nonatomic) NSMutableDictionary *infoDic;
@end

@implementation CargoidentificationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主认证"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    if (self.isRevamp == YES) {
        self.infoDic = @{}.mutableCopy;
        [ConfigModel showHud:self];
        [HttpRequest postPath:@"_xianshi_good_001" params:nil resultBlock:^(id responseObject, NSError *error) {
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
}

- (IBAction)seletedImageAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageWith:self Value:^(UIImage *images) {
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
        if (self.isRevamp == YES) {
            secondVC.isRevamp = YES;
            secondVC.infoDic = self.infoDic;
        }
        [self.navigationController pushViewController:secondVC animated:YES];
    }
    
}

- (void) setIdCardImageValue:(UIImage *)idCardImageValue{
    _idCardImageValue = idCardImageValue;
    self.idCardImageView.image = idCardImageValue;
}

- (void) setInfoDic:(NSMutableDictionary *)infoDic{
    _infoDic = infoDic;
    self.realNameTextField.text = validString(infoDic[@"linkname"]);
    self.idCardTextField.text = validString(infoDic[@"id_num"]);
    self.idCardImageValue = [NSString stringWithFormat:@"%@",infoDic[@"hand_img"]].urlImage;
}

@end
