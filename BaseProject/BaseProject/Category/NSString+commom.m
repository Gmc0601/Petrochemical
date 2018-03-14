//
//  NSString+commom.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "NSString+commom.h"

@implementation NSString (commom)

- (BOOL)isBlankString
{
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0);
}

/**
 字符串为 nil， NSNull 或者为空字符串
 
 @param string 字符串
 @return YES or NO
 */
+ (BOOL)stringIsNilOrEmpty:(NSString *)string
{
    return !([string isKindOfClass:[NSString class]] && ![string isKindOfClass:[NSNull class]] && string.length);
}

/**
 stringIsNilOrEmpty 与 isBlankString 的合并判断
 
 @param string input string
 @return YES or NO
 */
+ (BOOL)stringIsNilOrBlank:(NSString *)string
{
    return [self stringIsNilOrEmpty: string] || [string isBlankString];
}


@end
