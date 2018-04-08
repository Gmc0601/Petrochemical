//
//  CompleteAddressViewController.h
//  BaseProject
//
//  Created by DCQ on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseTableView.h"
typedef NS_ENUM(NSInteger,  CompleteAddressType){
    CompleteAddressType_nomarl = 0,
    CompleteAddressType_loading   ,
    CompleteAddressType_unLoading
};


@interface CompleteAddressViewController : BaseTableView
@property(nonatomic, assign) CompleteAddressType chooseType;
@property(nonatomic, assign) NSInteger chooseIndex;
@property(nonatomic, copy) void(^completeAddressInfoBlock)(NSDictionary *addressInfo,NSInteger index);

@end
