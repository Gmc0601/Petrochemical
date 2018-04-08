//
//  HomeCarViewModel.m
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HomeCarViewModel.h"

@implementation HomeCarViewModel

- (instancetype)init {
    if(self == [super init]) {
        _homeCarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            self.page = 1; self.dataArr = [NSMutableArray new];
            self.haveMore = YES;
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:@(self.page) forKey:@"page"];
                [dic setValue:self.data forKey:@"data"];
                [dic setValue:@"20" forKey:@"size"];
                if (self.page == 1) {
                    self.haveMore = YES;
                    [self.dataArr removeAllObjects];
                }
                if (!self.data) {
                    [dic setValue:@"1000" forKey:@"data"];
                }else {
                    if ([self.data isEqualToString:@"不限"]) {
                        self.data = @"1000";
                    }
                    [dic setValue:self.data forKey:@"data"];
                }
                
                if(self.origin){
                    [dic setValue:self.origin forKey:@"origin"];
                }
                
                if(self.description) {
                    [dic setValue:self.destination forKey:@"destination"];
                }
                [HttpRequest postPath:@"_homepage_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        NSArray *infoArr = datadic[@"info"];
                        [self.dataArr addObjectsFromArray:[HomeCarModel mj_objectArrayWithKeyValuesArray:infoArr]];
                        if (infoArr.count == 20) {
                            self.page ++;
                        }else {
                            self.haveMore = NO;
                        }
                        [subscriber sendNext:self.dataArr];
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
