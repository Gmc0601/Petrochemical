//
//  CarCell.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarCell.h"
@interface CarCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textfeild;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation CarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textfeild.enabled = NO;
    self.lineV.backgroundColor = UIColorFromHex(0xE3E3E3);
    self.titleLabel.textColor = UIColorFromHex(0x242424);
    
}
- (void)setupImg:(NSString *)imgName withTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder{
    self.iconImgV.image = [UIImage imageNamed:imgName];
//    if (imgName.length > 0) {
//        self.iconImgV.hidden = NO;
//    }else{
//        self.iconImgV.hidden = YES;
//    }
    self.titleLabel.text = title;
    self.textfeild.text = content;
    self.textfeild.placeholder =  placeholder;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
