//
//  CarsDetialViewController.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"


typedef enum CarDetialType{
    CarsDetail = 0,
    MycarsDetial
}CarDetialType;

@interface CarsDetialViewController : BaseViewController

@property (nonatomic , copy) NSString *idStr;

@property (nonatomic, assign) CarDetialType type;

@end
