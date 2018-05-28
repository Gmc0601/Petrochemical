//
//  LoginViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
#import "CCWebViewViewController.h"
#import <YYKit.h>
#import "ViewController.h"
#import "TBNavigationController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.LoginBtn.userInteractionEnabled = NO;
    [self.LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.LoginBtn.backgroundColor = ThemeBlue;
    self.codeBtn.backgroundColor = ThemeBlue;
     [self.phoneText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.codeText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    if (textField == self.phoneText) {
        if (string.length == 0) return YES;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        if (newtxt.length > 11) return NO;
    }
    
    if (textField == self.codeText) {
        if (string.length == 0) return YES;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        if (newtxt.length > 4) return NO;
    }
    
    
    return YES;
    
}

- (void)back:(UIButton *)sender {
    if (self.homeBlocl) {
        self.homeBlocl();
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
   
    
}

- (void)textchange {
    
    if (self.phoneText.text.length == 11 && self.codeText.text.length == 4) {
        self.LoginBtn.userInteractionEnabled = YES;
        self.LoginBtn.backgroundColor = RGBColor(102, 143, 218);
        [self.LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)codeBtnClick:(id)sender {
//    [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
    
    if (self.phoneText.text.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入11位有效手机号" andView:nil];
        return;
    }
    WeakSelf(weak);
    NSDictionary *dic = @{
                          @"mobile" : self.phoneText.text,
                          };
    [HttpRequest postPath:@"_sms_002" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
            __block int timeout=59 ; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
//                        [weak.codeBtn setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
                        [weak.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }

    }];
    
   
}
- (IBAction)loginBtnClick:(id)sender {
    //  登录
    

    NSDictionary *dic = @{
                          @"mobile" : self.phoneText.text,
                          @"code" : self.codeText.text,
                          @"user_type" : @"2",
                          };
    WeakSelf(weak);
    [HttpRequest postPath:@"_login_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            NSDictionary *data = datadic[@"info"];
            NSString *user_token = data[@"userToken"];
            [ConfigModel saveBoolObject:YES forKey:IsLogin];
            [ConfigModel saveString:user_token forKey:UserToken];
            [self presentViewController:[ViewController new] animated:YES completion:nil];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }


    }];
}


- (IBAction)userAgreeClick:(id)sender {
    CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
    vc.titlestr = @"注册协议";
    vc.UrlStr = @"http://116.62.142.20/Public/zcxy";
    vc.backmiss = YES;
    TBNavigationController *na = [[TBNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:na animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
