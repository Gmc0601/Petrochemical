//
//  ViewController.m
//  BaseProject
//
//  Created by cc on 2017/6/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"
#import "TBTabBarController.h"
#import "DeliveryTypeView.h"
#import "CarListViewController.h"
#import "GoodsListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deliveryAction) name:@"MidelTabbarItem_Noti"   object:nil];
    TBTabBarController *tab = [[TBTabBarController alloc] init];
    [self addChildViewController:tab];
    [self.view addSubview:tab.view];
}
- (void)deliveryAction{
    
    DeliveryTypeView * deliveryView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DeliveryTypeView class]) owner:nil options:nil].firstObject;
    deliveryView.frame =CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    deliveryView.backgroundColor = [UIColor clearColor];
    deliveryView.selectedBlock = ^(DeliverType type) {
        switch (type) {
            case DeliverType_close:
                 [self gotoClose];
                break;
            case DeliverType_goods:
                [self gotoGoods];
                break;
            case DeliverType_car:
                [self gotoCar];
                break;
            default:
                break;
        }
    };
    deliveryView.tag =  9898989;
    [[UIApplication sharedApplication].keyWindow addSubview:deliveryView];
}

- (void)gotoClose{
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 9898989) {
          [obj removeFromSuperview];
        }
    }];

 
}
- (void)gotoCar{
   
    [self gotoClose];
    CarListViewController * carListVC = [[CarListViewController alloc]init];
    [self.navigationController pushViewController:carListVC animated:YES];
}
- (void)gotoGoods{
   [self gotoClose];
    GoodsListViewController * goodsListVC = [[GoodsListViewController alloc]init];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
