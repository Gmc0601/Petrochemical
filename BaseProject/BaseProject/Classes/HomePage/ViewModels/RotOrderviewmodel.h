//
//  RotOrderviewmodel.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewModel.h"
#import "RotCarinfoModel.h"

@interface RotOrderviewmodel : BaseViewModel

@property (nonatomic, copy) NSString *good_num, *grab_weight, *json;

@property (nonatomic, strong) RACCommand *carinfoCommand, *rotOrderCommand;

@end
