

//
//  GoodsChooseCell.m
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsChooseCell.h"
typedef NS_ENUM(NSInteger ,ButtonContentType){
    
    ButtonContentType_imageRight  = 0,
    ButtonContentType_imageCenter     ,
};
@interface GoodsChooseCell ()
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;

@end
@implementation GoodsChooseCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)setupSelectedStete:(BOOL)isSelected{
    
    self.goodsBtn.selected = isSelected;
    CGColorRef  borderColor ;
    if (isSelected) {
        borderColor = UIColorFromHex(0x028BF3).CGColor;
    }else{
        borderColor = UIColorFromHex(0xA2A2A2).CGColor;
    }
    
    self.goodsBtn.layer.borderColor = borderColor;
    self.goodsBtn.layer.borderWidth = 1;
    self.goodsBtn.layer.masksToBounds = YES;
    self.goodsBtn.layer.cornerRadius = 2;
}
- (void)setupGoodsInfo:(NSDictionary *)info{
    
    [self.goodsBtn setTitle:info[@"type"] forState:UIControlStateNormal];
    [self.goodsBtn addTarget:self action:@selector(goodsAction:) forControlEvents:UIControlEventTouchUpInside];
    [GoodsChooseCell setupButtonContent:self.goodsBtn withType:ButtonContentType_imageRight withSpacing:2];
}


- (void)goodsAction:(id)sender{
    if (self.buttonBlock) {
        self.buttonBlock(self.indexPath);
    }
}


+ (void)setupButtonContent:(UIButton  *)button  withType:(ButtonContentType) type withSpacing:(CGFloat)spac  {
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    if (type == ButtonContentType_imageRight) {
        
        //在使用一次titleLabel和imageView后才能正确获取titleSize
        CGSize titleSize = button.titleLabel.bounds.size;
        CGSize imageSize = button.imageView.bounds.size;
        CGFloat interval = 4.0;
        if (spac != -9999) {
            interval = spac;
        }
        button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
    }else if (type == ButtonContentType_imageCenter){
        
        // the space between the image and text
        CGFloat spacing = 4.0;
        if (spac != -9999) {
            spacing = spac;
        }
        // lower the text and push it left so it appears centered
        //  below the image
        CGSize imageSize = button.imageView.image.size;
        button.titleEdgeInsets = UIEdgeInsetsMake(
                                                  0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        button.imageEdgeInsets = UIEdgeInsetsMake(
                                                  - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
        
        // increase the content height to avoid clipping
        CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
        button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
        
    }
    
}

@end

