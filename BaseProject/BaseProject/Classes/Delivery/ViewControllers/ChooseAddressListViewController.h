//
//  ChooseAddressListViewController.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseTableView.h"

typedef NS_ENUM(NSInteger, ChooseAddressType){
     ChooseAddressType_nomarl = 0,
     ChooseAddressType_loading   ,
     ChooseAddressType_unLoading
};
@interface ChooseAddressListViewController : BaseTableView
@property(nonatomic, assign) ChooseAddressType chooseType;
@property(nonatomic, assign) NSInteger chooseIndex;
@property(nonatomic, copy) void(^chooseAddressInfoBlock)(NSDictionary *addressInfo,NSInteger index);
@property(nonatomic, copy) void(^ChooseAddressBlock)(NSString *name);
@end
