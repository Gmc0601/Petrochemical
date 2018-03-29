//
//  BannerModel.m
//  BaseProject
//
//  Created by Jason on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
@end
