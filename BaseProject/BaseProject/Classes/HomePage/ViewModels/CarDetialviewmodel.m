//
//  CarDetialviewmodel.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarDetialviewmodel.h"

@implementation CarDetialviewmodel

- (instancetype)init {
    if (self == [super init]) {
        _carDetialCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dic = @{@"id" : self.id };
                [HttpRequest postPath:@"_car_particulars_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        NSDictionary *dic = datadic[@"info"];
                        CarDetailModel *model = [CarDetailModel mj_objectWithKeyValues:dic];
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    }else {
                        NSString *str = datadic[@"info"];
                        [ConfigModel mbProgressHUD:str andView:nil];
                        [subscriber sendCompleted];
                    }
                }];
                return nil;
            }];
        }];
    }
    return self;
}

@end
