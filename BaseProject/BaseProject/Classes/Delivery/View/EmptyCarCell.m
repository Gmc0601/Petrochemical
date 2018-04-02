
//
//  EmptyCarCell.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "EmptyCarCell.h"
@interface EmptyCarCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNum;
@property (weak, nonatomic) IBOutlet UIImageView *selectedimgV;

@property (weak, nonatomic) IBOutlet UILabel *maxLoading;
@end
@implementation EmptyCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.carNum.backgroundColor = UIColorFromHex(0xE0C123);
}
- (void)setupName:(NSString *)name  withCarNum:(NSString *)carNum withMaxLoding:(NSString *)max withSelected:(BOOL )isSelected{
    
    if (isSelected) {
        self.selectedimgV.hidden = NO;
    }else{
        self.selectedimgV.hidden = YES;
    }
    self.nameLabel.text = name;
    self.carNum.text = carNum;
    self.maxLoading.text = max?[NSString stringWithFormat:@"最大载重  %@ 吨", max]:@"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
