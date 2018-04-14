//
//  TimeManage.h
//  BaseProject
//
//  Created by cc on 2018/4/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManage : NSObject

+ (NSString *)getToday:(NSString *)date;

- (NSString *)timeStr:(long long)timestamp;

@end
