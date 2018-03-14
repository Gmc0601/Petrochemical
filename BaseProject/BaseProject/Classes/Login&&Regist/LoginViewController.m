//
//  LoginViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
//#import "AddmobileViewController.h"
//#import "UserAgreeViewController.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "CCWebViewViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomerTitle:@"登录"];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"login_remove"] action:@selector(dismiss)];
    [self addRightBarButtonItemWithTitle:@"注册" action:@selector(regist) color:UIColorFromHex(0xF5A623)];
    self.loginBtn.userInteractionEnabled = NO;
    self.loginBtn.alpha = 0.6;
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    
}
//  注册
- (void) regist {
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (IBAction)forgetBtnClick:(id)sender {
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneText) {
        if (string.length == 0) return YES;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        if (newtxt.length > 11) return NO;
    }
    
    if (textField == self.pwdText) {
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
    if (self.phoneText.text.length == 11 && self.pwdText.text.length == 4) {
        self.loginBtn.userInteractionEnabled = YES;
        self.loginBtn.alpha = 1.0;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)loginBtnClick:(id)sender {
    //  登录
//    NSDictionary *dic = @{
//                          @"phone" : self.phoneText.text,
//                          @"vcode" : self.codeText.text,
//                          @"os" : @"0",
//                          @"clientid" : [ConfigModel getStringforKey:GTclientId],
//                          };
//    WeakSelf(weak);
//    [HttpRequest postPath:@"Public/login" params:dic resultBlock:^(id responseObject, NSError *error) {
//        if([error isEqual:[NSNull null]] || error == nil){
//            NSLog(@"success");
//        }
//        NSDictionary *datadic = responseObject;
//        if ([datadic[@"success"] intValue] == 1) {
//            
//            NSDictionary *data = datadic[@"data"];
//            NSString *phone = data[@"phone"];
//            NSString *nick_name = [NSString stringWithFormat:@"%@",data[@"nick_name"]];
//            NSString *head_imgurl = data[@"head_imgurl"];
//            NSString *user_token = data[@"user_token"];
//            [ConfigModel saveBoolObject:YES forKey:IsLogin];
//            [ConfigModel saveString:user_token forKey:UserToken];
//            [ConfigModel saveString:phone forKey:User_phone];
//            [ConfigModel saveString:nick_name forKey:User_nickname];
//            [ConfigModel saveString:head_imgurl forKey:User_headimage];
//            if ([data[@"status"] intValue] == 0) {
//                [ConfigModel saveBoolObject:YES forKey:User_State];
//            }else {
//                [ConfigModel saveBoolObject:NO forKey:User_State];
//            }
//            
//            [weak dismissViewControllerAnimated:YES completion:nil];
//            
//        }else {
//            NSString *str = datadic[@"msg"];
//            [ConfigModel mbProgressHUD:str andView:nil];
//        }
//    }];
}

- (IBAction)weichatClick:(id)sender {
    
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
//        if (error) {
//            NSLog(@"...%@", error);
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//
//
//            NSDictionary *dic = @{
//                                  @"wx_openid" : resp.openid,
//                                  @"clientid" : [ConfigModel getStringforKey:GTclientId],
//                                  @"os" : @"0"
//                                  };
//            WeakSelf(weak);
//            [HttpRequest postPath:@"Public/wxlogin" params:dic resultBlock:^(id responseObject, NSError *error) {
//                if([error isEqual:[NSNull null]] || error == nil){
//                    NSLog(@"success");
//                }
//                NSDictionary *datadic = responseObject;
//                if ([datadic[@"success"] intValue] == 1) {
//
//                    NSDictionary *data = datadic[@"data"];
//                    if (IsNULL(data)) {
//                        AddmobileViewController *vc = [[AddmobileViewController alloc] init];
//                        vc.wx_openid = resp.openid;
//                        vc.wx_nickname = resp.name;
//                        vc.wx_headimgurl = resp.iconurl;
//                        [weak.navigationController pushViewController:vc animated:YES];
//                        return ;
//                    }
//                    NSString *phone = data[@"phone"];
//                    NSString *nick_name = [NSString stringWithFormat:@"%@",data[@"nick_name"]];
//                    NSString *head_imgurl = data[@"head_imgurl"];
//                    NSString *user_token = data[@"user_token"];
//                    [ConfigModel saveBoolObject:YES forKey:IsLogin];
//                    [ConfigModel saveString:user_token forKey:UserToken];
//                    [ConfigModel saveString:phone forKey:User_phone];
//                    [ConfigModel saveString:nick_name forKey:User_nickname];
//                    [ConfigModel saveString:head_imgurl forKey:User_headimage];
//                    if ([data[@"status"] intValue] == 0) {
//                        [ConfigModel saveBoolObject:YES forKey:User_State];
//                    }else {
//                        [ConfigModel saveBoolObject:NO forKey:User_State];
//                    }
//
//                    [weak dismissViewControllerAnimated:YES completion:nil];
//
//                }else {
//                    NSString *str = datadic[@"msg"];
//                    [ConfigModel mbProgressHUD:str andView:nil];
//                }
//            }];
//
//
//
//        }
//    }];
}

//- (IBAction)userAgreeClick:(id)sender {
//    CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
//    vc.titlestr = @"注册协议";
//    vc.UrlStr = @"http://116.62.142.20/Public/zcxy";
//    [self.navigationController pushViewController:vc animated:YES];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
