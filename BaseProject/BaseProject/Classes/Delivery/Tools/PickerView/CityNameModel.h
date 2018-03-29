//
//  CityNameModel.h
//  选择城市Demo
//
//  Created by ZSMAC on 2017/10/19.
//  Copyright © 2017年 ZSMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityNameModel : NSObject
@property(nonatomic,retain)NSArray * province;
@property(nonatomic,assign)NSUInteger index;
@end

@interface province : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray * city;
@property(nonatomic,assign)NSUInteger index;
@end


@interface city : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray * district;
@property(nonatomic,assign)NSUInteger index;
@end

@interface district : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSUInteger index;
@end

