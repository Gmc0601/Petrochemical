//
//  GoodsUnloadingCell.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsUnloadingCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) void(^delUnloadingBlock)(NSIndexPath * indexPath);
- (void)setupDelHidden:(BOOL)hidden;
- (void)setupTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder;
@end
