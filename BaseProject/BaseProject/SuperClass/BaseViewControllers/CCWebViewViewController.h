//
//  CCWebViewViewController.h
//  CCWebView
//
//  Created by cc on 2017/11/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+TS_JavaScriptContext.h"

@protocol JSObjcDelegate <JSExport>

- (void)getUserToken;

- (void)toLogin;

- (void)reload;

//public void showShare(String title, String content, String url,String imgUrl)

- (void)showShare:(NSString *)title :(NSString *)content :(NSString *)url :(NSString *)imgUrl;


@end

@interface CCWebViewViewController : BaseViewController
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *UrlStr;

@property (nonatomic, copy) NSString *titlestr;

@property (nonatomic, assign) BOOL backmiss;
- (void)reload;
@end
