//
//  InformationVideoTableViewCell.m
//  BaseProject
//
//  Created by Yitian on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "InformationVideoTableViewCell.h"

@implementation InformationVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(NSDictionary *)dataDic{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"img"]?:@""] placeholderImage:DefaultImage];
    self.nameLabel.text = dataDic[@"title"];
    self.dateLabel.text = dataDic[@"create_time"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
