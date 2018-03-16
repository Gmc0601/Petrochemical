//
//  InformationImageTableViewCell.m
//  BaseProject
//
//  Created by Yitian on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "InformationImageTableViewCell.h"

@implementation InformationImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 3;
    self.headImageView.layer.masksToBounds = YES;
    // Initialization code
}

-(void)setData:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"path"]?:@""] placeholderImage:DefaultImage];
    self.nameLable.text = dataDic[@"name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
