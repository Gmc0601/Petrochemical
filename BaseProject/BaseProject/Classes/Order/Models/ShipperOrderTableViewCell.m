//
//  ShipperOrderTableViewCell.m
//  BaseProject
//
//  Created by Yitian on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShipperOrderTableViewCell.h"

@implementation ShipperOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setData:(NSDictionary *)dataDic{
    //1待装货2运输中3已结束4全部
    self.orderNumberLabel.text = [NSString stringWithFormat:@"货单号%@",dataDic[@"good_num"]];
    self.carLabel.text = [NSString stringWithFormat:@"%ld辆车运输",[dataDic[@"car_num"] integerValue]];
    self.startAreaLabel.text = validString(dataDic[@"loading"]);
    self.startAddressLabel.text = validString(dataDic[@"loading_address"]);
    self.endAddressLabel.text = validString(dataDic[@"unload"]);
    self.endAreaLabel.text = validString(dataDic[@"unload_address"]);
    self.typeLabel.text = dataDic[@"type"];
    self.quantityLabel.text = [NSString stringWithFormat:@"共%@吨",dataDic[@"weight"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
