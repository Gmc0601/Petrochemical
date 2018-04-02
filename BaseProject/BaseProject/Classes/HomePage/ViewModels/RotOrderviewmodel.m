//
//  RotOrderviewmodel.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "RotOrderviewmodel.h"

@implementation RotOrderviewmodel


- (instancetype)init {
    if (self == [super init]) {
        
        _carinfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            self.dataArr = [[NSMutableArray alloc] init];
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dic = @{@"onlypasscheck": @"1"};
                [HttpRequest postPath:@"_user_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    NSLog(@"^#%@",responseObject );
                    NSDictionary *datadic = responseObject;
                    if ([datadic[@"error"] intValue] == 0) {
                        NSArray *arr = datadic[@"info"];
                        self.dataArr = [RotCarinfoModel mj_objectArrayWithKeyValuesArray:arr];
                        [subscriber sendNext:self.dataArr];
                        [subscriber sendCompleted];
                    }else {
                        NSString *str = datadic[@"info"];
                        [ConfigModel mbProgressHUD:str andView:nil];
                    }
                }];
                return nil;
            }];
        }];
        
        
        _rotOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSDictionary *dic = @{
                                      @"good_num" : self.good_num,
                                      @"grab_weight" : self.grab_weight,
                                      @"json" : self.json
                                      };
                [HttpRequest postPath:@"_grab_indent_001" params:dic resultBlock:^(id responseObject, NSError *error) {
                    if([error isEqual:[NSNull null]] || error == nil){
                        NSLog(@"success");
                        NSDictionary *datadic = responseObject;
                        if ([datadic[@"error"] intValue] == 0) {
                            [subscriber sendNext:@"success"];
                            [subscriber sendCompleted];
                        }else {
                            NSString *str = datadic[@"info"];
                            [ConfigModel mbProgressHUD:str andView:nil];
                            [subscriber sendCompleted];
                        }
                    }

                    
                }];
                return nil;
            }];
        }];
        
    }
    return self;
}

@end
