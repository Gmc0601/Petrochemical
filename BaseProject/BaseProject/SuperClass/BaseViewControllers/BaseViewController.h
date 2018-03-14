//
//  BaseViewController.h
//  BaseProject
//
//  Created by cc on 2017/6/22.
//  Copyright © 2017年 cc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIViewController+BarButton.h"
@interface BaseViewController : UIViewController

//  设置标题
-(void)setCustomerTitle:(NSString *)title;
//  设置头视图
- (void)setTitleImage:(NSString *)imageStr;


@end
