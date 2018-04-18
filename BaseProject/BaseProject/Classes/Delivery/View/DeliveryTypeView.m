
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
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;

@end

@implementation DeliveryTypeView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.alpha = 0.6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.bgView addGestureRecognizer:tap];
    
    [self addAnimation:self.carBtn];
    [self addAnimation:self.goodsBtn];
  
}

- (void)addAnimation:(UIButton *)btn{
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [btn.layer
     addAnimation:pulse forKey:nil];
}
- (void)tapAction {
    [self closeAction:nil];
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
        self.selectedBlock(DeliverType_car);
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
