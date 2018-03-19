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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomerTitle:@"消息"];
    self.oneNumberLabel.layer.cornerRadius = 3;
    self.oneNumberLabel.layer.masksToBounds = YES;
    
    self.twoNuberLabel.layer.cornerRadius = 3;
    self.twoNuberLabel.layer.masksToBounds = YES;
    
    self.oneNumberLabel.text = [NSString stringWithFormat:@"%d   ",0];
    self.twoNuberLabel.text = [NSString stringWithFormat:@"%d   ",0];
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

- (IBAction)clickSystemMessage:(id)sender {
    
    SystemMessageViewController *con = [[SystemMessageViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)clickTransportDynamics:(id)sender {
    TransportDynamicsViewController *con = [[TransportDynamicsViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}
@end
