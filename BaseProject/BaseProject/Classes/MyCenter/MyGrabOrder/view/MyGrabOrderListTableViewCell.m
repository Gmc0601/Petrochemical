//
//  MyGrabOrderListTableViewCell.m
//  BaseProject
//
//  Created by 桃子leas on 2018/4/1.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyGrabOrderListTableViewCell.h"

@interface MyGrabOrderListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *weighLabel;

@end

@implementation MyGrabOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDic:(NSDictionary *)dic{
    _dic = dic;
    NSString *orderNum = validString(dic[@"good_num"]);
    self.orderNumberLabel.text = [NSString stringWithFormat:@"货单号:%@",orderNum];
    self.carTypeLabel.text = @"用车";
    self.timeLabel.text = validString(dic[@"use_time"]);
    self.nameLabel.text = @"";
    self.startLabel.text = validString(dic[@"loading"]);
    self.endLabel.text = validString(dic[@"unload"]);
    NSString *otherStr = [NSString stringWithFormat:@"%@     共%@吨     ¥%@/吨",dic[@"type"],dic[@"weight"],dic[@"rough_weight"]];
    self.otherLabel.text = otherStr;
    self.weighLabel.text = [NSString stringWithFormat:@"%@吨",dic[@"rough_weight"]];
}
@end
