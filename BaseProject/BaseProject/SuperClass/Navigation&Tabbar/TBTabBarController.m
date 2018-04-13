//
//  TBTabBarController.m
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "TBTabBarController.h"
#import "HomepageViewController.h"
#import "OrderViewController.h"
#import "InformationViewController.h"
#import "MyCenterViewController.h"

#import "ViewController.h"
#import "TBNavigationController.h"
#import "TBTabBar.h"

@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 49)];
    backView.backgroundColor = [UIColor redColor];
    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.opaque = YES;
    // 初始化所有控制器
    [self setUpChildVC];
//    //  设置中间按钮
    [self setUpMidelTabbarItem];
}
#pragma mark -创建tabbar中间的tabbarItem
- (void)setUpMidelTabbarItem {
    
    TBTabBar *tabBar = [[TBTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    
    __weak typeof(self) weakSelf = self;
    [tabBar setDidClickPublishBtn:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MidelTabbarItem_Noti" object:nil];
    }];
    
}

#pragma mark -初始化所有控制器 

- (void)setUpChildVC {

    HomePageViewController *homepage = [[HomePageViewController alloc] init];
    [self setChildVC:homepage title:@"首页" image:@"shouyehui" selectedImage:@"shouye"];
    
    OrderViewController *order = [[OrderViewController alloc] init];
    [self setChildVC:order title:@"订单" image:@"dingda" selectedImage:@"dingdandian"];
    
    InformationViewController *video = [[InformationViewController alloc] init];
    [self setChildVC:video title:@"咨询" image:@"zixun" selectedImage:@"zixundian"];
    
    MyCenterViewController *myVC = [[MyCenterViewController alloc] init];
    [self setChildVC:myVC title:@"我的" image:@"wode" selectedImage:@"wodedian"];

}

- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
    dicts[NSForegroundColorAttributeName] = ThemeBlue;
    dicts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dicts forState:UIControlStateSelected];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

@end
