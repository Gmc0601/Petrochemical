
//
//  GoodsUnloadingCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsUnloadingCell.h"
@interface GoodsUnloadingCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation GoodsUnloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineV.backgroundColor = UIColorFromHex(0xE0E0E0);
    self.tf.delegate = self;
    self.tf.enabled = NO;
}

- (IBAction)deleteAction:(id)sender {
    if (self.delUnloadingBlock) {
        self.delUnloadingBlock(self.indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder{
    self.titleLabel.text = title;
    self.tf.text = content;
    self.tf.placeholder =  placeholder;
}
- (void)setupDelHidden:(BOOL)hidden{
    
    self.delBtn.hidden = hidden;
}
@end
