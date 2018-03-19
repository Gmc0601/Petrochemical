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

@interface UserInformationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (strong, nonatomic) UIImage *headerImageValue;

@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"个人资料"];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

#pragma mark -- method

- (IBAction)settingHeaderImageAction:(id)sender {
    __weak typeof(self) weakself = self;
    [LeasCustomAlbum getImageValue:^(UIImage *images) {
        weakself.headerImageValue = images;
    }];
    
}
- (IBAction)settingNickNameAction:(id)sender {
    SettingNickNameViewController *settingNickVC = [SettingNickNameViewController new];
    settingNickVC.nickNameTextField.text = @"nickname";
    [self.navigationController pushViewController:settingNickVC animated:YES];
}

- (IBAction)logoutAction:(id)sender {
}


#pragma mark -- setter
- (void) setHeaderImageValue:(UIImage *)headerImageValue{
    _headerImageValue = headerImageValue;
    self.headerImageView.image = headerImageValue;
}
@end
