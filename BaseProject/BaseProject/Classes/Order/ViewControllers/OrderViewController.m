//
//  OrderViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货主订单"];
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"xin"] action:@selector(rightBarClick)];
}

- (void)rightBarClick {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
