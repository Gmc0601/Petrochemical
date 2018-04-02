//
//  GoodsDetialViewController.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"

typedef enum GoodDetialType{
    GoodsDetail = 0,
    MyGoodsDetial
}GoodDetialType;

@interface GoodsDetialViewController : BaseViewController

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) GoodDetialType type;

@end
