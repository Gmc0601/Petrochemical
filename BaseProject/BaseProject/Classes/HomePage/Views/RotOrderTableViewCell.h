//
//  RotOrderTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotCarinfoModel.h"

@interface RotOrderTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) int num, maxNum,id;

@property (nonatomic) BOOL check, canadd;

@property (nonatomic, strong) UILabel *carNumlab, *titleLab;

@property (nonatomic, strong) UISwitch *swi;

@property (nonatomic, strong) UITextField *numFile;

@property (nonatomic, strong) UIButton *checkLogo;

@property (nonatomic, strong) UIButton *addButn, *deleteButn;

@property (nonatomic, strong) RotCarinfoModel *model;

@property (nonatomic, copy) void(^checkBlock)(NSString * num, BOOL check);

@end
