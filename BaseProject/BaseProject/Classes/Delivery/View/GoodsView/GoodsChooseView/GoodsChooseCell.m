

//
//  GoodsChooseCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsChooseCell.h"
@interface GoodsChooseCell ()
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;

@end
@implementation GoodsChooseCell
- (void)setupGoodsInfo:(NSDictionary *)info{
    
    [self.goodsBtn setTitle:info[@"type"] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
