
//
//  DeliveryTypeView.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "DeliveryTypeView.h"
@interface DeliveryTypeView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation DeliveryTypeView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.alpha = 0.9;
}
- (IBAction)closeAction:(id)sender {
    if (self.selectedBlock) {
        self.selectedBlock(DeliverType_close);
    }
}
- (IBAction)goodsAction:(id)sender {
    if (self.selectedBlock) {
        self.selectedBlock(DeliverType_goods);
    }
}
- (IBAction)carAction:(id)sender {
    if (self.selectedBlock) {
        self.selectedBlock(DeliverType_close);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
