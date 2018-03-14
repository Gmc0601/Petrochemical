//
//  NSString+commom.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (commom)
- (BOOL)isBlankString;
+ (BOOL)stringIsNilOrBlank:(NSString *)string;
+ (BOOL)stringIsNilOrEmpty:(NSString *)string;

@end
