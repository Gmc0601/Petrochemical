//
//  UIButton+message.m
//  BaseProject
//
//  Created by Yitian on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "UIButton+message.h"

@implementation UIButton (message)

-(void)updateMessage{
    NSDictionary *dic = @{
                          @"userToken":@"e56d19bd376625cc2bc7aa6ae40e385a",
                          };
    
    [HttpRequest postPath:@"_shuliangs_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSDictionary *infoDic = dic[@"info"];
            NSInteger message_num = [infoDic[@"message_num"] integerValue];
            NSInteger carriage_num = [infoDic[@"carriage_num"] integerValue];
            if (message_num>0||carriage_num>0) {
                self.selected = YES;
            }
            else{
                 self.selected = NO;
            }
            
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
    }];
}
@end
