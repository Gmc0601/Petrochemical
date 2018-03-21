//
//  TransportDynamicsTableViewCell.m
//  BaseProject
//
//  Created by Yitian on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "TransportDynamicsTableViewCell.h"

@implementation TransportDynamicsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(NSDictionary *)dataDic{
    self.numberLabel.text = [NSString stringWithFormat:@"货单号：%@",dataDic[@"good_num"]];
    self.nameLabel.text = [NSString stringWithFormat:@"[%@ %@]",dataDic[@"license"],dataDic[@"car_name"]];;
    self.detailLabel.text = validString(dataDic[@"dynamic"]);
    
    NSString *dateString = dataDic[@"create_time"];
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    if (array.count>=2) {
        self.dateLabel.text = array.firstObject;
        self.timeLabel.text = array[1];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
