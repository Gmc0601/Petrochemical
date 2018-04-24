//
//  HomeCarModel.h
//  BaseProject
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface HomeCarModel : BaseModel
@property (nonatomic , copy) NSString              * origin, *linkname;
@property (nonatomic , copy) NSString              * destination;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * loading_time;
@property (nonatomic , copy) NSString              * empty;
@property (nonatomic , copy) NSString              * license;
@property (nonatomic , copy) NSString              * avatar_url;
@property (nonatomic, copy) NSString *is_plat, *fast;
@end
