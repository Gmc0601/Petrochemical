//
//  GoodsDetailModel.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface Xiehuo :NSObject
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * unload_address;
@property (nonatomic , copy) NSString              * lon;
@property (nonatomic , copy) NSString              * unload;

@end

@interface GoodsDetailModel : BaseModel

@property (nonatomic , copy) NSString              * typeid;
@property (nonatomic , copy) NSString              * user_type;
@property (nonatomic , copy) NSString              * account_type;
@property (nonatomic , copy) NSString              * surplus_weight;
@property (nonatomic , copy) NSString              * mileage;
@property (nonatomic , copy) NSString              * weight;
@property (nonatomic , copy) NSString              * indent_type;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * use_time;
@property (nonatomic , copy) NSString              * loading_address;
@property (nonatomic , copy) NSString              * good_price;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * good_status;
@property (nonatomic , copy) NSString              * good_num;
@property (nonatomic , copy) NSArray<Xiehuo *>              * xiehuo;
@property (nonatomic , copy) NSString              * loading;
@property (nonatomic , copy) NSString              * cost, *hot_line;

@end
