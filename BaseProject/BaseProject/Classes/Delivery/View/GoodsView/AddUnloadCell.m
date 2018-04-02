

//
//  AddUnloadCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddUnloadCell.h"
@interface AddUnloadCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation AddUnloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.borderColor = UIColorFromHex(0x525C66).CGColor;
    self.addBtn.layer.borderWidth = 0.5;
    self.addBtn.layer.cornerRadius =4;
}
- (IBAction)addAction:(id)sender {
    if (self.addUnloadingBlock) {
        self.addUnloadingBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
