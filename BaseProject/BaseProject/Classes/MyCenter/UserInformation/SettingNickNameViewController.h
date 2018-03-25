//
//  SettingNickNameViewController.h
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingNickNameViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (copy, nonatomic) void(^retunrEditValue)(NSString *text);
@end
