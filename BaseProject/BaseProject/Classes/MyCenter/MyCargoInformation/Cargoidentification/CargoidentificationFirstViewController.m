//
//  CargoidentificationFirstViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CargoidentificationFirstViewController.h"
#import "CargoidentificationSecondViewController.h"

@interface CargoidentificationFirstViewController ()

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImageView;


@end

@implementation CargoidentificationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主认证"];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (IBAction)seletedImageAction:(id)sender {
}

- (IBAction)jumpButtonAction:(id)sender {
    CargoidentificationSecondViewController *secondVC = [CargoidentificationSecondViewController new];
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
