//
//  TYCyclePagerViewCell.h
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
@interface TYCyclePagerViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *label;
@property (nonatomic, weak, readonly) UIImageView *bannerImage;
@property (nonatomic, strong)BannerModel *model;
@end
