//
//  EmptyCarCell.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyCarCell : UITableViewCell
- (void)setupName:(NSString *)name  withCarNum:(NSString *)carNum withMaxLoding:(NSString *)max withSelected:(BOOL)isSelected;
@end
