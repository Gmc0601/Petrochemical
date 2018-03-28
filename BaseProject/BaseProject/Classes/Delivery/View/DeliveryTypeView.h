//
//  DeliveryTypeView.h
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DeliverType) {
    DeliverType_close = 0,
    DeliverType_goods  ,
    DeliverType_car  ,
};

typedef void(^DeliverTypeSelectedBlock)(DeliverType type);

@interface DeliveryTypeView : UIView
@property(nonatomic, copy) DeliverTypeSelectedBlock selectedBlock;
@end
