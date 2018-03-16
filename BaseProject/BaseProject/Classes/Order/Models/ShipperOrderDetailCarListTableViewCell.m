//
//  ShipperOrderDetailCarListTableViewCell.m
//  BaseProject
//
//  Created by Yitian on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ShipperOrderDetailCarListTableViewCell.h"

@implementation ShipperOrderDetailCarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carNumberView.layer.cornerRadius = 3;
    self.carNumberView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    self.carNumberLabel.layer.cornerRadius = 3;
    self.carNumberLabel.layer.masksToBounds = YES;
    
    self.carNumberLabel.layer.borderWidth = 1;
    self.carNumberLabel.layer.borderColor = RGBColor(135, 135, 135).CGColor;
    
    // Initialization code
}

-(void)setData:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"path"]?:@""] placeholderImage:DefaultImage];
    self.nameLabel.text = dataDic[@"name"];
    self.statusLabel.text = dataDic[@"status"];
    self.carNumberLabel.text  =  dataDic[@"carNumber"];
    self.remarkLabel.text = @"司机已接单，将按时前往装货点进行装货";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
