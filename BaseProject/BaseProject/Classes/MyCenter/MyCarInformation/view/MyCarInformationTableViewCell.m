//
//  MyCarInformationTableViewCell.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyCarInformationTableViewCell.h"

@interface MyCarInformationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateimageView;

@end

@implementation MyCarInformationTableViewCell

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
    self.nameLabel.text = validString(dic[@"car_name"]);
    self.licenseLabel.text = validString(dic[@"license"]);
    self.typeLabel.text = validString(dic[@"type"]);
    self.loadLabel.text = [NSString stringWithFormat:@"%@吨",dic[@"load"]];
    int car_status = [validString(dic[@"car_status"]) intValue];
    switch (car_status) {
        case 1:{
            self.stateimageView.image = [UIImage imageNamed:@"shenhezhonf"];
        }
            break;
        case 2:{
            self.stateimageView.image = [UIImage imageNamed:@"tongguo"];
        }
            break;
        case 3:{
            self.stateimageView.image = [UIImage imageNamed:@"shenheshibai"];
        }
            break;
        default:
            break;
    }
}
@end
