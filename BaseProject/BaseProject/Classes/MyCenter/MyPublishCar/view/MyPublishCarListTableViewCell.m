//
//  MyPublishCarListTableViewCell.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyPublishCarListTableViewCell.h"

@interface MyPublishCarListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;


@end

@implementation MyPublishCarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.carNumberLabel.layer.borderWidth = 1;
    self.carNumberLabel.layer.backgroundColor = UIColorFromHex(0x000000).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDicModel:(NSDictionary *)dicModel{
    _dicModel = dicModel;
    self.nameLabel.text = validString(dicModel[@"car_name"]);
    self.carNumberLabel.text = validString(dicModel[@"license"]);
    [self.addressLabel setTitle:[NSString stringWithFormat:@" %@",validString(dicModel[@"empty"])] forState:UIControlStateNormal];
    [self.timeLabel setTitle:[NSString stringWithFormat:@" %@",validString(dicModel[@"loading_time"])] forState:UIControlStateNormal];
    self.startLabel.text = validString(dicModel[@"origin"]);
    self.endLabel.text = validString(dicModel[@"destination"]);
}


@end
