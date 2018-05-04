//
//  HomeCarTableViewCell.h
//  BaseProject
//
//  Created by cc on 2018/4/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCarModel.h"
@interface HomeCarTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *lumingLogo, *locaLogo, *callLogo, *headimage, *toLogo, *fastlogo;

@property (nonatomic, strong) UILabel *startLab, *endLab, *locationLab, *nickLabLab, *timeLab;

@property (nonatomic, strong) HomeCarModel *model;

@end
