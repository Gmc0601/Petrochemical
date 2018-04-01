//
//  MyCenterUserGuideViewController.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCenterUserGuideViewController.h"

@interface MyCenterUserGuideViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MyCenterUserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"使用指南"];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
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
