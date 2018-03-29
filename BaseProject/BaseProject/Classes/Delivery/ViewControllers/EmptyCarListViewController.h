//
//  EmptyCarListViewController.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseTableView.h"

typedef void(^SelectedEmptyCarBlock)(NSDictionary * carInfo);
@interface EmptyCarListViewController : BaseTableView
@property(nonatomic, copy) SelectedEmptyCarBlock emptyCarBlock;
@end
