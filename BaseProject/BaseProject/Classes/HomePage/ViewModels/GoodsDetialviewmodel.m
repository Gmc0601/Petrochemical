//
//  GoodsDetialviewmodel.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsDetialviewmodel.h"

@implementation GoodsDetialviewmodel

- (instancetype)init {
    if (self == [super init]) {
        _goodDetialCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dic = @{@"id" : self.id };
                [HttpRequest postPath:@"_good_particulars_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    NSDictionary *datadic = responseObject;
                    NSLog(@"goods:%@", responseObject);
                    if ([datadic[@"error"] intValue] == 0) {
                        NSDictionary *dic = datadic[@"info"];
                        GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dic];
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
