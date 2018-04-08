//
//  GoodsInfoCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsInfoCell.h"
@interface GoodsInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end
@implementation GoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tf.enabled = NO;
    [self.tf addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldChangeText:(UITextField *)tf{
    
    NSLog(@"===%@==",tf.text);
    if (self.inputTextBlock) {
        self.inputTextBlock(tf.text,self.row);
    }
}
- (void)setupTFEnabled:(BOOL)enabled  withKeyboardType:(UIKeyboardType)type{
    self.tf.enabled = enabled;
    self.tf.keyboardType = type;
}
- (void)setupTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder{
    self.titleLabel.text = title;
    self.tf.text = content;
    self.tf.placeholder =  placeholder;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

