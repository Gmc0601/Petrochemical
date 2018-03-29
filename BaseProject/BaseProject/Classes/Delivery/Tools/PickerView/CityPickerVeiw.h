//
//  CityPickerVeiw.h
//  丢必得
//
//  Created by ZSMAC on 17/9/6.
//  Copyright © 2017年 zhangwenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityPickerVeiw : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UIView * bageView;
@property(nonatomic,copy) void(^CityBlock)(NSString *);
@property(nonatomic,strong)NSString * showSelectedCityNameStr;
@property(nonatomic,assign)NSInteger col;
-(void)show;
@end
