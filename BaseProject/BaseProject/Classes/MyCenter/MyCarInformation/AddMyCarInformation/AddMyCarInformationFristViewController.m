//
//  AddMyCarInformationFristViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddMyCarInformationFristViewController.h"
#import "NSString+commom.h"
#import "AddMyCarInformationSecondViewController.h"

@interface AddMyCarInformationFristViewController (){
    int timeNum;
}
@property(nonatomic,strong)NSTimer *timer;//计时
@property (weak, nonatomic) IBOutlet UITextField *nickNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@end

@implementation AddMyCarInformationFristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"添加车辆"];
    self.automaticallyAdjustsScrollViewInsets = YES;
}


- (IBAction)nextButtonAction:(id)sender {
    if (self.nickNameLabel.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请填写司机姓名" andView:nil];
        return;
    }
    if (self.phoneLabel.text.isPhoneNumber == NO) {
        [ConfigModel mbProgressHUD:@"请填写正确的手机号码" andView:nil];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"请填写正确的验证码" andView:nil];
        return;
    }
    
    AddMyCarInformationSecondViewController *addCar2VC = [AddMyCarInformationSecondViewController new];
    addCar2VC.nickNameStr = self.nickNameLabel.text;
    addCar2VC.phoneStr = self.phoneLabel.text;
    addCar2VC.codeStr = self.codeTextField.text;
    [self.navigationController pushViewController:addCar2VC animated:YES];
}

- (IBAction)timerLabelGestureAction:(id)sender {
    if (self.phoneLabel.text.isPhoneNumber) {
        [HttpRequest postPath:@"_sms_001" params:@{@"mobile":self.phoneLabel.text} resultBlock:^(id responseObject, NSError *error) {
            NSDictionary *dic = responseObject;
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
                timeNum = 60;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didtimerClicked:) userInfo:nil repeats:YES];
            }else {
                NSString *errorStr = dic[@"info"];
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    }else{
        [ConfigModel mbProgressHUD:@"请输入正确的手机号码" andView:nil];
    }
}



//timer计时器
-(void)didtimerClicked:(NSTimer *)timer{
    timeNum -= 1;
    if (timeNum>0) {
        self.timerLabel.userInteractionEnabled = NO;
        NSString *codeTitleStr = [NSString stringWithFormat:@"%ds后获取",timeNum];
        self.timerLabel.text = codeTitleStr;
        self.timerLabel.backgroundColor = [UIColor grayColor];
    }else{
        self.timerLabel.userInteractionEnabled = YES;
        self.timerLabel.text = @"获取验证码";
        [self.timer invalidate];//停止timer
        self.timer = nil;//销毁timer
        self.timerLabel.backgroundColor = UIColorFromHex(0x028BF3);
    }
}
@end
