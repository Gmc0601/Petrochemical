//
//  BannnerCell.h
//  HuoHaoApp
//
//  Created by liqu on 16/8/2.
//  Copyright © 2016年 com.HuoHao.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
//#import "BannerModel.h"

#define Banner_CELL  @"Banner_Cell"                //在售状态

typedef void(^ClickViewBlock)(NSInteger index);

@interface BannerCell : UITableViewCell<SDCycleScrollViewDelegate>

@property (nonatomic, copy)ClickViewBlock clickViewBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat )heigh;

- (void)setContent:(NSMutableArray *)model;

- (void)setimage:(NSMutableArray *)array;

@end
