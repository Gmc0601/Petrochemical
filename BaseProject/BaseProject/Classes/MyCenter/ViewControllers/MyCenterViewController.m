//
//  MyCenterViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserInformationViewController.h"

#import "MyCarInformationListViewController.h"
#import "CargoidentificationFirstViewController.h"
#import "CargoidentificationProgressViewController.h"
#import "MyPublishListViewController.h"
#import "MyPublishCarListViewController.h"
#import "MyGrabOrderListViewController.h"
#import "MyCenterUserGuideViewController.h"
#import "InviteFrendViewController.h"

@interface MyCenterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *user_statusLabel;

@property (weak, nonatomic) IBOutlet UIView *shareMainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareMainViewH;

@property (nonatomic, strong) UITableView *noUseTableView;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (nonatomic, assign) int user_status;

@property (strong, nonatomic) NSMutableArray *linkPlatformArray;
@property (strong, nonatomic) NSMutableDictionary *shareInfoDic;
@property (assign, nonatomic) int  app_onoff;
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
    [self openShareAction];
    [self creatCarType];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self cargoOwnerPlan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) cargoOwnerPlan {
    //[user_status] => 1  认证进度 1待审核 2已通过 3认证失败
    [HttpRequest postPath:@"_userinfo_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            if ([info isKindOfClass:[NSDictionary class]]) {
                self.userInfo = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
- (void) openShareAction{
    [HttpRequest postPath:@"_share_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            if ([info isKindOfClass:[NSDictionary class]]) {
                self.shareInfoDic = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
#pragma mark -- method

- (IBAction)settingUserInfoAction:(id)sender {
    UserInformationViewController *userInfoVC = [UserInformationViewController new];
    userInfoVC.userinfo = self.userInfo;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
- (IBAction)myCarInfoAction:(id)sender {
    MyCarInformationListViewController *carInfoVC = [MyCarInformationListViewController new];
    [self.navigationController pushViewController:carInfoVC animated:YES];
}
- (IBAction)myCargoInfoAction:(id)sender {
    if (self.user_status == 2) {
        return;
    }
    if (self.user_status == 4) {
        CargoidentificationFirstViewController *CargoidentificationVC1 = [CargoidentificationFirstViewController new];
        [self.navigationController pushViewController:CargoidentificationVC1 animated:YES];
    }else{
        CargoidentificationProgressViewController *progressVC = [CargoidentificationProgressViewController new];
        [self.navigationController pushViewController:progressVC animated:YES];
    }
}
- (IBAction)myPublishCargoAction:(id)sender {
    MyPublishListViewController *publishVC = [MyPublishListViewController new];
    [self.navigationController pushViewController:publishVC animated:YES];
}
- (IBAction)myPublishCarAction:(id)sender {
    MyPublishCarListViewController *publishVC = [MyPublishCarListViewController new];
    [self.navigationController pushViewController:publishVC animated:YES];
}
- (IBAction)myRobOrderAction:(id)sender {
    MyGrabOrderListViewController *robOrderVC = [MyGrabOrderListViewController new];
    [self.navigationController pushViewController:robOrderVC animated:YES];
}
- (IBAction)linkPlatformAction:(id)sender {
    [HttpRequest postPath:@"_hot_line_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *info = dic[@"info"];
            if ([info isKindOfClass:[NSArray class]]) {
                self.linkPlatformArray = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
- (IBAction)UserGuideAction:(id)sender {
    [HttpRequest postPath:@"_operating_guide_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSString *info = dic[@"info"];
            MyCenterUserGuideViewController *VC = [MyCenterUserGuideViewController new];
            VC.urlStr = info;
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
- (IBAction)invitefriendsinviteFriendsAction:(id)sender {
    InviteFrendViewController *inviteFrendVC = [InviteFrendViewController new];
    inviteFrendVC.info = self.shareInfoDic;
    [self.navigationController pushViewController:inviteFrendVC animated:YES];
}

#pragma mark -- setter
- (void) setUserInfo:(NSMutableDictionary *)userInfo{
    _userInfo = userInfo;
    self.user_status = [[NSString stringWithFormat:@"%@",userInfo[@"approve"]] intValue];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:validString(userInfo[@"avatar_url"])] placeholderImage:DefaultImage];
    NSString *name = validString(userInfo[@"nickname"]);
    if (name.length > 6) {
        name = [name substringFromIndex:name.length - 6];
    }
    self.userNickNameLabel.text = name;
}
- (void) setUser_status:(int)user_status{
    _user_status = user_status;
    switch (user_status) {
        case 1:
            self.user_statusLabel.text = @"待审核";
            break;
        case 2:
            self.user_statusLabel.text = @"已通过";
            break;
        case 3:
            self.user_statusLabel.text = @"认证失败";
            break;
            case 4:
            self.user_statusLabel.text = @"未认证";
            break;
        default:
            break;
    }
}

- (void) setLinkPlatformArray:(NSMutableArray *)linkPlatformArray{
    _linkPlatformArray = linkPlatformArray;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancelAction setValue:UIColorFromHex(0x666666) forKey:@"_titleTextColor"];
    [alertVC addAction:cancelAction];
    for (NSDictionary *info in linkPlatformArray) {
        NSString *title = [NSString stringWithFormat:@"%@: %@",info[@"name"],info[@"mobile"]];
        UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",info[@"mobile"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        [okAction1 setValue:UIColorFromHex(0x333333) forKey:@"_titleTextColor"];
        [alertVC addAction:okAction1];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void) setShareInfoDic:(NSMutableDictionary *)shareInfoDic{
    _shareInfoDic = shareInfoDic;
    _app_onoff = [validString(shareInfoDic[@"app_onoff"]) intValue];
    if (_app_onoff == 2) {
        self.shareMainViewH.constant = 54;
    }else{
        self.shareMainViewH.constant = 0;
    }
}

- (void) creatCarType{
    [HttpRequest postPath:@"_tanklist_001" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *info = dic[@"info"];
            if ([info isKindOfClass:[NSArray class]]) {
                NSMutableArray *tempArray = @[].mutableCopy;
                for (NSDictionary *dic in info) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *tempDic = @{}.mutableCopy;
                        [tempDic setValue:dic[@"id"] forKey:@"type"];
                        [tempDic setValue:dic[@"type"] forKey:@"linkname"];
                        [tempArray addObject:tempDic];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setValue:tempArray forKey:@"creatCarTypeArray"];
            }
        }else {
            
        }
    }];
}
@end
