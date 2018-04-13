//
//  TimeManage.m
//  BaseProject
//
//  Created by cc on 2018/4/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "TimeManage.h"

@implementation TimeManage


+ (NSString *)getToday:(NSString *)date {
    NSString *str = date;
    NSRange range;
    range = [str rangeOfString:@"日"];
    NSRange range2;
    range2 = [str rangeOfString:@"月"];
    NSRange range3;
    range3 = [str rangeOfString:@"年"];
    NSRange month ;
    month.location = range3.location + 1;
    month.length = range2.location - range3.location - 1;
    
    NSString *monthStr = [str substringWithRange:month];
//    NSLog(@"month:%@",monthStr);
    
    NSRange day;
    day.location = range2.location + 1;
    day.length = range.location - range2.location - 1;
    NSString *datStr = [str substringWithRange:day];
//    NSLog(@"dat:%@",datStr);
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
//    NSLog(@"现在是%ld年" , comp.year);
//    NSLog(@"现在是%ld月 " , comp.month);
//    NSLog(@"现在是%ld日" , comp.day);
//    NSLog(@"现在是%ld时" , comp.hour);
//    NSLog(@"现在是%ld分" , comp.minute);
//    NSLog(@"现在是%ld秒" , comp.second);
//    NSLog(@"现在是星期%ld" , comp.weekday);
    
    NSString *nowMonth = [NSString stringWithFormat:@"%ld", comp.month];
    NSString *nowDay = [NSString stringWithFormat:@"%ld", comp.day];
    
    
    if ([nowMonth intValue] == [monthStr intValue]) {
        if ([nowDay intValue] == [datStr intValue]) {
            //  今天
            return @"今天";
        }else if (([nowDay intValue] - 1) == [datStr intValue]){
            // 昨天
            return @"昨天";
        }else {
            return @"其他";
        }
    }else {
        return @"其他";
    }
}

- (NSString *)timeStr:(long long)timestamp
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFmt.dateFormat = @"HH:mm";
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    return [dateFmt stringFromDate:msgDate];
}

@end
