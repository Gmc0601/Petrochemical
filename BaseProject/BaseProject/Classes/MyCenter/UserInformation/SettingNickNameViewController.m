//
//  SettingNickNameViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SettingNickNameViewController.h"
#import "UITextField+MyProperty.h"


@interface SettingNickNameViewController ()

@end

@implementation SettingNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"修改昵称"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.nickNameTextField becomeFirstResponder];
    self.nickNameTextField.maxWords = 6;
}


- (IBAction)saveButtonAction:(id)sender {
    _retunrEditValue(self.nickNameTextField.text);
    [self.nickNameTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
