//
//  HomeGoodsViewModel.h
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewModel.h"
#import "HomeGoodsModel.h"

@interface HomeGoodsViewModel : BaseViewModel

@property (nonatomic, copy) NSString *destination, *loading, *type, *data;

@property (nonatomic, strong) RACCommand *homeGoodsCommad;

@end
