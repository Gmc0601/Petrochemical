//
//  GoodsTableViewCell.m
//  BaseProject
//
//  Created by Jason on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsTableViewCell.h"
@interface GoodsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLaber;

@property (weak, nonatomic) IBOutlet UILabel *goodsInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *useCarTimeLaber;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *addLab;

@end
@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(HomeGoodsModel *)model {
    self.addLab.layer.masksToBounds = YES;
    self.addLab.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds =  YES;
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.backgroundColor = RGBColor(239, 240, 241);
    self.headImageView.layer.borderWidth =  1;
    self.headImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.addLab.backgroundColor = UIColorFromHex(0xff2640);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    self.startPlaceLabel.text = [NSString stringWithFormat:@"%@→%@", model.loading, model.unload];
    self.goodsInfoLabel.text = [NSString stringWithFormat:@"%@ 共%@吨,剩%@吨", model.type, model.weight, model.surplus_weight];
    self.useCarTimeLaber.text = [NSString stringWithFormat:@"用车时间：%@", model.use_time];
}

@end
