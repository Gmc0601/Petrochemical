//
//  CarDetialviewmodel.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewModel.h"
#import "CarDetailModel.h"

@interface CarDetialviewmodel : BaseViewModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) RACCommand *carDetialCommand;

@end
