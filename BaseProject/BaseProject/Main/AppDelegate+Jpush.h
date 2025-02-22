//
//  AppDelegate+Jpush.h
//  English
//
//  Created by cc on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AppDelegate.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate (Jpush)<JPUSHRegisterDelegate>

- (void)initJpushapplication:(UIApplication *)application optins:(NSDictionary *)launchOptions;

@end
