//
//  RobbingOrdersViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "RobbingOrdersViewController.h"

@interface RobbingOrdersViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNuberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameOfGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightOfGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformQtoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
- (IBAction)clickCall:(id)sender;


@property(nonatomic,strong)NSDictionary *infoDic;
@end

@implementation RobbingOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillInfo{
    self.driverLabel.text = [NSString stringWithFormat:@"%@-%@",self.infoDic[@"number"],self.infoDic[@"driver"]];
    self.applyWeightLabel.text = [NSString stringWithFormat:@"%@吨",self.infoDic[@"applyWeight"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",validString(self.infoDic[@"phone"])];
    self.orderNuberLabel.text = self.infoDic[@"orderNumber"];
    self.startAreaLabel.text = validString(self.infoDic[@"startArea"]);
    self.startAddressLabel.text = validString(self.infoDic[@"startAddress"]);
    self.endAreaLabel.text = validString(self.infoDic[@"endArea"]);
    self.endAddressLabel.text = validString(self.infoDic[@"endAddress"]);
    self.distanceLabel.text = [NSString stringWithFormat:@"%@公里/%@小时",self.infoDic[@""],self.infoDic[@""]];
    self.durationLabel.text = self.infoDic[@"orderNumber"];
    self.nameOfGoodsLabel.text = self.infoDic[@"orderNumber"];
    self.weightOfGoodsLabel.text = [NSString stringWithFormat:@"%@吨",self.infoDic[@"applyWeight"]];
    self.ownerQuoteLabel.text = [NSString stringWithFormat:@"货主报价：%@/吨",self.infoDic[@"applyWeight"]];
    self.platformQtoteLabel.text = [NSString stringWithFormat:@"平台价%@/吨",self.infoDic[@"applyWeight"]];
     self.costLabel.text = [NSString stringWithFormat:@"%@元",self.infoDic[@"applyWeight"]];
     self.remarksLabel.text = validString(self.infoDic[@"remark"]);
    self.applyDateLabel.text = validString(self.infoDic[@"applyDate"]);
    NSInteger state = [self.infoDic[@"state"] integerValue];
    if (state==0) {
        self.stateImageView.image = [UIImage imageNamed:@"shenhezhonf"];
        self.stateDetailLabel.text = validString(self.infoDic[@"stateValue"]);
    }
    else if (state==1) {
        self.stateImageView.image = [UIImage imageNamed:@"tongguo"];
        self.stateDetailLabel.text = validString(self.infoDic[@""]);
    }
    else if (state==2) {
        self.stateImageView.image = [UIImage imageNamed:@"shenheshibai"];
        self.stateDetailLabel.text = validString(self.infoDic[@"stateValue"]);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickCall:(id)sender {
    NSString *phoneString=[NSString stringWithFormat:@"tel://%@",@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}
@end
