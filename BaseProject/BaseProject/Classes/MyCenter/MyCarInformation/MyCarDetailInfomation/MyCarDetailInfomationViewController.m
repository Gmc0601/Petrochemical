//
//  MyCarDetailInfomationViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCarDetailInfomationViewController.h"
#import "Masonry.h"
#import "MyCarDetailUpdatePhoneViewController.h"
#import "AddMyCarInformationSecondViewController.h"
#import "TPImageShow.h"

@interface MyCarDetailInfomationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *updatePhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *drive_img;
@property (weak, nonatomic) IBOutlet UIImageView *run_img;


@property (strong, nonatomic) NSMutableDictionary *dataSource;
@end

@implementation MyCarDetailInfomationViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupDataSource];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setCustomerTitle:@"车辆详情"];
}
- (void) setupDataSource{
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_wxcar_details_001" params:@{@"id":self.carId} resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *info = dic[@"info"];
            if ([info isKindOfClass:[NSDictionary class]]) {
                self.dataSource = info.mutableCopy;
            }
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}

#pragma mark -- method

- (IBAction)showDrive_imgAction:(id)sender {
    
    NSMutableArray *imagesMutableArray=[[NSMutableArray alloc] init];
    
    NSString *imageUrl = [self setImageWithUrl:validString(self.dataSource[@"drive_img"]) andWithSize:@"600"];
    [imagesMutableArray addObject:imageUrl];
    [TPImageShow imageShowWithData:imagesMutableArray andSmallImageData:nil currentIndex:0 clickImage:nil];
}

- (IBAction)showRun_imgAction:(id)sender {
    
    NSMutableArray *imagesMutableArray=[[NSMutableArray alloc] init];
    
    NSString *imageUrl = [self setImageWithUrl:validString(self.dataSource[@"run_img"]) andWithSize:@"600"];
    [imagesMutableArray addObject:imageUrl];
    [imagesMutableArray addObject:validString(self.dataSource[@"run_img"])];
    [TPImageShow imageShowWithData:imagesMutableArray andSmallImageData:nil currentIndex:0 clickImage:nil];
}


- (void) deleteCarInfo{
    __weak typeof(self) weakslef = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除该车辆吗？" message:@"删除后，该车辆将无法接单，对应的司机也无法登录App。" preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakslef deleteAction];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void) deleteAction{
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_usercar_delete_001" params:@{@"id":self.carId} resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            [ConfigModel mbProgressHUD:@"删除成功" andView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
- (IBAction)updatePhoneAction:(id)sender {
    MyCarDetailUpdatePhoneViewController *updatePhoneVC = [MyCarDetailUpdatePhoneViewController new];
    updatePhoneVC.carId = self.carId;
    [self.navigationController pushViewController:updatePhoneVC animated:YES];
}
- (void) updateCarInfoAction{
    AddMyCarInformationSecondViewController *updateInfoVC = [AddMyCarInformationSecondViewController new];
    updateInfoVC.carInfo = self.dataSource;
    updateInfoVC.carId = self.carId;
    [self.navigationController pushViewController:updateInfoVC animated:YES];
}
#pragma mark -- setter
- (void) setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    self.nameLabel.text = validString(dataSource[@"car_name"]);
    self.phoneLabel.text = validString(dataSource[@"car_mobile"]);
    self.licenseLabel.text = validString(dataSource[@"license"]);
    self.loadLabel.text = [NSString stringWithFormat:@"%@",validString(dataSource[@"load"])];
    self.typeLabel.text = validString(dataSource[@"type"]);
    [self.drive_img sd_setImageWithURL:[NSURL URLWithString:validString(dataSource[@"drive_img"])] placeholderImage:DefaultImage];
    [self.run_img sd_setImageWithURL:[NSURL URLWithString:validString(dataSource[@"run_img"])] placeholderImage:DefaultImage];
    int car_status = [validString(dataSource[@"car_status"]) intValue];
    switch (car_status) {
        case 1:{
            self.statusLabel.text = @"车辆信息审核中，请耐心等待";
            self.statusLabel.textColor = UIColorFromHex(0x028BF3);
            self.statusImageView.image = [UIImage imageNamed:@"shenhezhonf"];
            self.updatePhoneButton.hidden = YES;
        }
            break;
        case 2:{
            self.statusLabel.text = @"审核通过，该车辆可以在平台进行抢单";
            self.statusLabel.textColor = UIColorFromHex(0x5AB56D);
            self.statusImageView.image = [UIImage imageNamed:@"tongguo"];
            self.updatePhoneButton.hidden = NO;
            UIButton *bottomButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"修改车辆信息" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = ThemeBlue;
                [button addTarget:self action:@selector(updateCarInfoAction) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [self.view addSubview:bottomButton];
            [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.height.equalTo(@49);
                make.right.equalTo(@0);
                make.bottom.equalTo(@-34);
            }];
            UIView *lineView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromHex(0xEFEFEF);
                view;
            });
            [self.view addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.height.equalTo(@2);
                make.bottom.equalTo(bottomButton.mas_top);
            }];
        }
            break;
        case 3:{
            NSString *reason = validString(dataSource[@"reason"]);
            self.statusLabel.text = [NSString stringWithFormat:@"审核不通过:\n原因:%@",reason];
            self.statusLabel.textColor = UIColorFromHex(0xFF0000);
            self.statusImageView.image = [UIImage imageNamed:@"shenheshibai"];
            self.updatePhoneButton.hidden = YES;
            UIButton *bottomButton = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"删除车辆" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x242424) forState:UIControlStateNormal];
                [button addTarget:self action:@selector(deleteCarInfo) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [self.view addSubview:bottomButton];
            [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenWidth/2));
                make.bottom.equalTo(@0);
            }];
            UIButton *bottomButton1 = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"修改车辆信息" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = ThemeBlue;
                [button addTarget:self action:@selector(updateCarInfoAction) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [self.view addSubview:bottomButton1];
            [bottomButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@0);
                make.height.equalTo(@49);
                make.width.equalTo(@(kScreenWidth/2));
                make.bottom.equalTo(@0);
            }];
            UIView *lineView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = UIColorFromHex(0xEFEFEF);
                view;
            });
            [self.view addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.height.equalTo(@2);
                make.bottom.equalTo(bottomButton.mas_top);
            }];
        }
            break;
        default:
            break;
    }
}


//查看大图

//图片处理
-(NSString *)setImageWithUrl:(NSString *)url andWithSize:(NSString *)sizeNum{
    
    //    NSLog(@"%@",url);
    NSString *string = nil;
    if (![url isEqual:[NSNull null]]&&url.length>=12) {
        
        if ([url containsString:@"wx."]) {
            return url;
        }
        else  if ([url containsString:@"vod."]) {//阿里云存储
            return url;
        }
        else{
            NSMutableString *urlPath = [[NSMutableString alloc]initWithString:url];
            urlPath = (NSMutableString *)[urlPath stringByReplacingOccurrencesOfString:@"images." withString:@"imageprocess."];
            string = [NSString stringWithFormat:@"%@@!%@",urlPath,sizeNum];

            return string;
        }
    }else if(![url isEqual:[NSNull null]]&&url.length<12){
        return url;
    }
    return string;
}

@end
