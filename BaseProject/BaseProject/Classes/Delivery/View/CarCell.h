//
//  CarCell.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell
- (void)setupImg:(NSString *)imgName withTitle:(NSString *)title withTextFeild:(NSString *)content withPlaceholder:(NSString *)placeholder;
@end
