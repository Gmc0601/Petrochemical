//
//  AddUnloadCell.h
//  BaseProject
//
//  Created by DCQ on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUnloadCell : UITableViewCell
@property(nonatomic, copy) void(^addUnloadingBlock)();
@end
