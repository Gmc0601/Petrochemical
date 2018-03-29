//
//  SureConditionCollectionViewCell.m
//  MultipleSelectedWindow
//
//  Created by 刘硕 on 2016/12/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureConditionCollectionViewCell.h"
#define SureQuickSetRed [UIColor \
colorWithRed:236.0/255.0 \
green:73.0/255.0 \
blue:73.0/255.0 \
alpha:1.0]
#define SureQuickSetWhite [UIColor \
colorWithRed:245.0/255.0 \
green:245.0/255.0 \
blue:245.0/255.0 \
alpha:1.0]
@implementation SureConditionCollectionViewCell

- (void)loadDataFromModel:(SureConditionModel *)model {
    _conditionLabel.text = model.title;
    if (model.isSelected) {
        _conditionLabel.backgroundColor = [UIColor whiteColor];
        _conditionLabel.textColor = UIColorFromHex(0x028BF3);
        _conditionLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.layer.borderColor = UIColorFromHex(0x028BF3).CGColor;
        self.layer.borderWidth = 0.5;
    } else {
        _conditionLabel.backgroundColor = [UIColor whiteColor];
        _conditionLabel.textColor = [UIColor blackColor];
        _conditionLabel.font = [UIFont systemFontOfSize:15.0];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = .5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = .5;
}

@end
