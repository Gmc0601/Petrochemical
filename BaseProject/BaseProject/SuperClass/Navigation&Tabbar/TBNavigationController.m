//
//  TBNavigationController.m
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "TBNavigationController.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
@interface TBNavigationController ()<UINavigationBarDelegate, UIGestureRecognizerDelegate>

@end

@implementation TBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//     设置导航栏背景
//    UIImage *bgImage = [[UIImage imageNamed:@"nab.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//    [[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//    设置导航栏背景色
    [self.navigationBar setBackgroundColor:[UIColor whiteColor]];
//     设置statusBar颜色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)popToBack
{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count > 1) {
        return YES;
    }else {
        return NO;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}


@end
