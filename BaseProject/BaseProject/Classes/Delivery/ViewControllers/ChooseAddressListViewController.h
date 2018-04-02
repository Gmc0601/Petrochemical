//
//  ChooseAddressListViewController.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseTableView.h"


@interface ChooseAddressListViewController : BaseTableView
@property(nonatomic, copy) void(^ChooseAddressBlock)(NSString *name);
@end
