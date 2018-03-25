//
//  InformationDetailViewController.h
//  BaseProject
//
//  Created by Yitian on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"

@interface InformationDetailViewController : BaseViewController

@property(nonatomic,assign)NSInteger type;//0:资讯详情；1：消息详情
@property(nonatomic,strong)NSString *idString;
@end
