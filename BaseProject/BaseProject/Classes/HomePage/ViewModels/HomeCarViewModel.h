//
//  HomeCarViewModel.h
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewModel.h"
#import "HomeCarModel.h"

@interface HomeCarViewModel : BaseViewModel

@property (nonatomic, copy) NSString *data, *origin, *destination;

@property (nonatomic, strong) RACCommand *homeCarCommand;

@end
