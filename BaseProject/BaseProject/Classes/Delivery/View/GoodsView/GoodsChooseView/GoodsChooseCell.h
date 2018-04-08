//
//  GoodsChooseCell.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GoodsChooseCell : UICollectionViewCell
@property(nonatomic, strong)  NSIndexPath *indexPath;
@property(nonatomic, copy) void(^buttonBlock)(NSIndexPath *indexPath);
- (void)setupGoodsInfo:(NSDictionary *)info;
- (void)setupSelectedStete:(BOOL)isSelected;
@end

