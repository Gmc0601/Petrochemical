//
//  CarDetailModel.h
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface CarDetailModel : BaseModel

@property (nonatomic , copy) NSString              * empty;
@property (nonatomic , copy) NSString              * lon;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * linkname;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * license;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * loading_time;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * load;
@property (nonatomic , copy) NSString              * origin;
@property (nonatomic , copy) NSString              * destination;
@property (nonatomic , copy) NSString              * status, *hot_line;

@end
