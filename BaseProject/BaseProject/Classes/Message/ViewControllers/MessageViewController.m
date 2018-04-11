//
//  MessageViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemMessageViewController.h"
#import "TransportDynamicsViewController.h"
@interface MessageViewController ()
- (IBAction)clickSystemMessage:(id)sender;
- (IBAction)clickTransportDynamics:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *oneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoNuberLabel;

@end

@implementation MessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDetail];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomerTitle:@"消息"];
    self.oneNumberLabel.layer.cornerRadius = 3;
    self.oneNumberLabel.layer.masksToBounds = YES;
    
    self.twoNuberLabel.layer.cornerRadius = 3;
    self.twoNuberLabel.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)requestDetail{
    NSString *usertoken = [ConfigModel getStringforKey:UserToken];
    NSDictionary *dic = @{
                          @"userToken":usertoken,
                          };
    
    [HttpRequest postPath:@"_shuliangs_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *infoDic = dic[@"info"];
            self.oneNumberLabel.text = [NSString stringWithFormat:@"%ld   ",[infoDic[@"message_num"] integerValue]];
            self.twoNuberLabel.text = [NSString stringWithFormat:@"%ld   ",[infoDic[@"carriage_num"] integerValue]];
            
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
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

- (IBAction)clickSystemMessage:(id)sender {
    
    SystemMessageViewController *con = [[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)clickTransportDynamics:(id)sender {
    TransportDynamicsViewController *con = [[TransportDynamicsViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
@end
