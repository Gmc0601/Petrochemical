//
//  MyPublishCargoDetailXiehuoView.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyPublishCargoDetailXiehuoView.h"

@interface MyPublishCargoDetailXiehuoView()

@end

@implementation MyPublishCargoDetailXiehuoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.unload_address.text = validString(dataDic[@"unload_address"]);
    self.unload.text = validString(dataDic[@"unload"]);
}
@end
