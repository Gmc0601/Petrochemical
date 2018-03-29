//
//  ChooseAddressSearchView.h
//  BaseProject
//
//  Created by DCQ on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseAddressSearchBlock)(NSString * inputText);
typedef void(^ChooseAddressAreaBlock)();
@interface ChooseAddressSearchView : UIView
@property(nonatomic, copy) ChooseAddressSearchBlock inputText;
@property(nonatomic, copy) ChooseAddressAreaBlock areaBlock;
- (void)setupArea:(NSString *)area;
@end
