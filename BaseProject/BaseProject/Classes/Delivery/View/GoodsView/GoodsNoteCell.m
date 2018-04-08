

//
//  GoodsNoteCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsNoteCell.h"
@interface GoodsNoteCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TTextView *tv;

@end
@implementation GoodsNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tv.placeholderColor = UIColorFromHex(0xc3c3c3);
    
    WeakSelf(weakSelf)
    [self.tv addTextDidChangeHandler:^(TTextView *textView) {
        StrongSelf(strongSelf)
        if (strongSelf.inputBlock) {
            strongSelf.inputBlock(textView.text);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
