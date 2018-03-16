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
    
    self.orderNumberLabel = dataDic[@"orderNumber"];
    self.carLabel.text = [NSString stringWithFormat:@"%ld辆车运输",[dataDic[@"carNumber"] integerValue]];
    self.startAreaLabel.text = validString(dataDic[@"startaddress"]);
    self.startAreaLabel.text = validString(dataDic[@"startArea"]);
    self.endAddressLabel.text = validString(dataDic[@"endaddress"]);
    self.endAreaLabel.text = validString(dataDic[@"endaddress"]);
    self.typeLabel.text = dataDic[@"type"];
    self.quantityLabel.text = dataDic[@"quantity"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
