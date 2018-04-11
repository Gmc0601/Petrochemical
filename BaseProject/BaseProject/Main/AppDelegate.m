//
//  AppDelegate.m
//  BaseProject
//
//  Created by cc on 2017/6/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TBNavigationController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKey.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"


@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate>
@property (strong, nonatomic) TencentOAuth* tencentOAuth;
@end

@implementation AppDelegate
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self selectedWXApi];
    [self selectedQQAction];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self configureAPIKey];
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        self.window.rootViewController = [LoginViewController new];
    }else {
       self.window.rootViewController = [ViewController new];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark -- share
- (void) selectedWXApi{
    [WXApi registerApp:@"wx6499f71fc4509030"];
}
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([[url scheme] isEqualToString:@"1106747618"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([[url scheme] isEqualToString:@"1106747618"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}
-(void) onResp:(BaseResp*)resp{
    NSString *str;
    if (resp.errCode == 0) {
        str = @"分享成功";
    }else{
        str = @"分享失败";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) selectedQQAction{
   
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1106747618" andDelegate:nil];
}

@end
