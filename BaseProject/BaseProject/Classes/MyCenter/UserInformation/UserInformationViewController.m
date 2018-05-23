//
//  UserInformationViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "UserInformationViewController.h"
#import "LeasCustomAlbum.h"
#import "SettingNickNameViewController.h"
#import "UIImage+MyProperty.h"

@interface UserInformationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (strong, nonatomic) UIImage *headerImageValue;

@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"个人资料"];
    [self setupDataSource];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void) setupDataSource{
    NSString *name = validString(self.userinfo[@"nickname"]);
    if (name.length > 6) {
        name = [name substringFromIndex:name.length - 6];
    }
    self.nickNameLabel.text = name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:validString(self.userinfo[@"avatar_url"])] placeholderImage:DefaultImage];
}
#pragma mark -- method

- (IBAction)settingHeaderImageAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageWith:self Value:^(UIImage *images) {
        weakself.headerImageValue = images;
    }];
    
}
- (IBAction)settingNickNameAction:(id)sender {
    __weak typeof(self) weakself = self;
    SettingNickNameViewController *settingNickVC = [SettingNickNameViewController new];
    settingNickVC.nickNameTextField.text = @"nickname";
    settingNickVC.retunrEditValue = ^(NSString *text) {
        [weakself updateNickName:text];
    };
    [self.navigationController pushViewController:settingNickVC animated:YES];
}

- (IBAction)logoutAction:(id)sender {
    [HttpRequest postPath:@"_logout_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        NSString *errorStr = dic[@"info"];
        [ConfigModel mbProgressHUD:errorStr andView:nil];
        if (errorint == 0 ) {
            [ConfigModel saveBoolObject:NO forKey:IsLogin];
            UnloginReturn
        }
    }];
}

- (void) updateNickName:(NSString *) nickName{
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
                          @"nickname":nickName
                          };
    [HttpRequest postPath:@"_update_userinfo_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            self.nickNameLabel.text = nickName;
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
- (void) updateHeaderImage:(NSString *) base64{
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
                          @"avatar_url":base64
                          };
    [HttpRequest postPath:@"_upload_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        NSString *errorStr = dic[@"info"];
        [ConfigModel mbProgressHUD:errorStr andView:nil];
        if (errorint == 0 ) {
            self.headerImageView.image = self.headerImageValue;
        }
        
    }];
}
#pragma mark -- setter
- (void) setHeaderImageValue:(UIImage *)headerImageValue{
    _headerImageValue = headerImageValue;
    [self updateHeaderImage:headerImageValue.base64String];
}
@end
