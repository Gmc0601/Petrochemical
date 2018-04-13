//
//  HomeGoodsModel.h
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface HomeGoodsModel : BaseModel
@property (nonatomic , copy) NSString              * unload;
@property (nonatomic , copy) NSString              * use_time;
@property (nonatomic , copy) NSString              * weight;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * loading;
@property (nonatomic , copy) NSString              * surplus_weight;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * avatar_url;
@property (nonatomic, copy) NSString *is_plat, *linkname;
@property (nonatomic, copy) NSString *transportation;
@end
