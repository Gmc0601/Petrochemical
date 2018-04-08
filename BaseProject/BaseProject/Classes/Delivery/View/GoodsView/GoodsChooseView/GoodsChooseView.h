//
//  GoodsChooseView.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsChooseView : UIView
@property(nonatomic,strong)UIView * bageView;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)showArray withSelectedGoodsIndex:(NSArray *)selectedGoodsIndexs;
@property(nonatomic, copy) void(^chooseBlock)(NSArray * selectedArray);
-(void)show;
@end

