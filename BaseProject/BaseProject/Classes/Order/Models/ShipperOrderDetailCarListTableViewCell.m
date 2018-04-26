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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"avatar_url"]?:@""] placeholderImage:DefaultImage];
    self.nameLabel.text = dataDic[@"car_name"];
    NSInteger state = [dataDic[@"carriage_status"] integerValue];//1待装货 2运输中 3已结束
    if (state==1) {
        self.statusLabel.text = @"待装货";
    }
    else if (state==2) {
        self.statusLabel.text = @"运输中";
    }
    else if (state==3) {
        self.statusLabel.text = @"已结束";
    }
   
    self.carNumberLabel.text  =  dataDic[@"license"];
    self.remarkLabel.text = validString(dataDic[@"carriage"]);
    self.quantityLabel.text = [NSString stringWithFormat:@"装货：%@吨",validString(dataDic[@"rough_weight"])];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
