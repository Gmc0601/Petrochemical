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

@end
@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HomeGoodsModel *)model {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    self.startPlaceLabel.text = [NSString stringWithFormat:@"%@→%@", model.loading, model.unload];
    self.goodsInfoLabel.text = model.type;
    self.useCarTimeLaber.text = [NSString stringWithFormat:@"用车时间：%@", model.use_time];
}

@end
