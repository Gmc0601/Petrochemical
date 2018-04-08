//
//  GoodsNoteCell.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTextView.h"
@interface GoodsNoteCell : UITableViewCell
@property(nonatomic, copy) void (^inputBlock)(NSString * inputText);
@end
