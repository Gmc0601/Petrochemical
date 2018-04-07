//
//  GoodsInfoCell.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoCell : UITableViewCell
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, copy) void(^inputTextBlock)(NSString *inputText,NSInteger row);
- (void)setupTFEnabled:(BOOL)enabled withKeyboardType:(UIKeyboardType)type;
- (void)setupTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder;
@end
