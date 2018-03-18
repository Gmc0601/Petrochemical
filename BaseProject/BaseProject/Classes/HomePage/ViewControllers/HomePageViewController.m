//
//  HomePageViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    
    
    NSDictionary *dic = @{
                          @"mobile" : @"17682318061"
                          };
    
    [HttpRequest postPath:@"_sms_002" params:dic resultBlock:^(id responseObject, NSError *error) {
        NSLog(@"%@", responseObject);
    }];
    
    
    
}
- (void)setNavigation {
//    rightBtn
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"xin"] action:@selector(rightBarClick)];
    
}

- (void)rightBarClick {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
