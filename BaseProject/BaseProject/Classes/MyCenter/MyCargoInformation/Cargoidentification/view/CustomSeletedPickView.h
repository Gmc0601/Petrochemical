//
//  CustomSeletedPickView.h
//  BaseProject
//
//  Created by 桃子leas on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomSeletedPickViewBlock)(NSDictionary *dic);
@interface CustomSeletedPickView : UIView

+ (void) creatCustomSeletedPickViewWithTitle:(NSString *) titleString value:(NSArray *) dataArray block:(CustomSeletedPickViewBlock) block;
@end
