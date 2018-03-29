//
//  CarTableViewCell.m
//  BaseProject
//
//  Created by Jason on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarTableViewCell.h"
@interface CarTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLaber;
@property (weak, nonatomic) IBOutlet UILabel *currentPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *useCarTimeLaber;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

@end
@implementation CarTableViewCell

+ (instancetype)xibTableViewCell {
     //在类方法中加载xib文件,注意:loadNibNamed:owner:options:这个方法返回的是NSArray,所以在后面加上firstObject或者lastObject或者[0]都可以;因为我们的Xib文件中,只有一个cell
     return [[[NSBundle mainBundle] loadNibNamed:@"XibTableViewCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HomeCarModel *)model {
    self.currentPlaceLabel.text = model.empty;
    self.startPlaceLabel.text = [NSString stringWithFormat:@"%@→%@", model.origin, model.destination];
    self.useCarTimeLaber.text = [NSString stringWithFormat:@"用车时间：%@", model.loading_time];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    self.carNumberLabel.text = model.license;
}

@end
