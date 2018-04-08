//
//  MyCarDetailUpdatePhoneViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCarDetailUpdatePhoneViewController.h"
#import "NSString+commom.h"

@interface MyCarDetailUpdatePhoneViewController (){
    int timeNum;
}
@property(nonatomic,strong)NSTimer *timer;//计时
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation MyCarDetailUpdatePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setCustomerTitle:@"修改手机号码"];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)updatePhoneAction:(id)sender {
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setValue:self.phoneLabel.text forKey:@"car_mobile"];
    [param setValue:self.codeTextField.text forKey:@"code"];
    [param setValue:self.carId forKey:@"id"];
    [ConfigModel showHud:self];
    [HttpRequest postPath:@"_amend_usercar_001" params:param resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        NSDictionary *dic = responseObject;
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *errorStr = dic[@"info"];
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}


@end
