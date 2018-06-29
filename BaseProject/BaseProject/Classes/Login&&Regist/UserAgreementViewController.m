

//
//  UserAgreementViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/6/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.title = @"注册协议";
    [self getNetworkData];
}
- (void)getNetworkData{
    NSDictionary * parameterDic = nil;
    WeakSelf(weakSelf)
    [HttpRequest postPath:@"_useragreement_002" params:nil resultBlock:^(id responseObject, NSError *error) {
         StrongSelf(strongSelf)
        [strongSelf loadWebView:responseObject[@"info"]];
    }];
}
- (void)loadWebView:(NSString *)url{
    NSURL * webUrl = [NSURL URLWithString:url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webUrl]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
