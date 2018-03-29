//
//  CityPickerVeiw.h
//  丢必得
//
//  Created by ZSMAC on 17/9/6.
//  Copyright © 2017年 zhangwenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PickerViewType) {
    PickerViewType_city = 0,
    PickerViewType_timer ,
};
@interface CityPickerVeiw : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIView * bageView;
- (instancetype)initWithFrame:(CGRect)frame withType:(PickerViewType )pickerType;

@property(nonatomic,copy) void(^CityBlock)(NSString *);
@property(nonatomic,strong)NSString * showSelectedCityNameStr;
@property(nonatomic,assign)NSInteger col;
-(void)show;
@end
