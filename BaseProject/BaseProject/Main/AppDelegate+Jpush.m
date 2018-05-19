//
//  AppDelegate+Jpush.m
//  English
//
//  Created by cc on 2018/3/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AppDelegate+Jpush.h"
#import "CCWebViewViewController.h"
#import "TBNavigationController.h"
//    极光  key
#define APPKey @"f81c26135b90337218d24c29"

@implementation AppDelegate (Jpush)


- (void)initJpushapplication:(UIApplication *)application optins:(NSDictionary *)launchOptions {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:APPKey
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSString *str = [NSString stringWithFormat:@"%@/user_token/%@",  userInfo[@"msg_url"], [ConfigModel getStringforKey:UserToken]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CCWebViewViewController *web = [[CCWebViewViewController alloc] init];
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//            [alter show];
            web.UrlStr = str;
//            [ConfigModel mbProgressHUD:str andView:nil];
            [self.window.rootViewController.navigationController pushViewController:web animated:YES];
            
        });
    });
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
   
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSString *str = [NSString stringWithFormat:@"%@/user_token/%@",  userInfo[@"msg_url"], [ConfigModel getStringforKey:UserToken]];
    
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [alter show];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //                vv.textstr = @"1";
            
//            CCWebViewViewController *orderListCtrl = [[CCWebViewViewController alloc] init];
//            orderListCtrl.UrlStr = str;
////            orderListCtrl.back = YES;
////            [ConfigModel mbProgressHUD:str andView:nil];
////            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
////            [alter show];
//            TBNavigationController *pushNav = [[TBNavigationController alloc] initWithRootViewController:orderListCtrl];
//            [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
            
        });
    });
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [application setApplicationIconBadgeNumber:0];
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:userInfo[@"aps"][@"alert"][@"body"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即查看", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        [ConfigModel mbProgressHUD:@"唤起跳转了" andView:nil];
        CCWebViewViewController *web = [[CCWebViewViewController alloc] init];
        web.UrlStr = @"www.baidu.com";
        [self.window.rootViewController.navigationController pushViewController:web animated:YES];
    }
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

@end
