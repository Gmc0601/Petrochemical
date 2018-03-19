//
//  MyCenterViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserInformationViewController.h"

#import "CargoidentificationFirstViewController.h"

@interface MyCenterViewController ()

@property (nonatomic, strong) UITableView *noUseTableView;

@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.noUseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.noUseTableView.scrollIndicatorInsets = self.noUseTableView.contentInset;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- method

- (IBAction)settingUserInfoAction:(id)sender {
    UserInformationViewController *userInfoVC = [UserInformationViewController new];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
- (IBAction)myCarInfoAction:(id)sender {
    
}
- (IBAction)myCargoInfoAction:(id)sender {
    CargoidentificationFirstViewController *CargoidentificationVC1 = [CargoidentificationFirstViewController new];
    [self.navigationController pushViewController:CargoidentificationVC1 animated:YES];
}
- (IBAction)myPublishCargoAction:(id)sender {
}
- (IBAction)myPublishCarAction:(id)sender {
}
- (IBAction)myRobOrderAction:(id)sender {
}
- (IBAction)linkPlatformAction:(id)sender {
}
- (IBAction)UserGuideAction:(id)sender {
}
- (IBAction)invitefriendsinviteFriendsAction:(id)sender {
}


@end
