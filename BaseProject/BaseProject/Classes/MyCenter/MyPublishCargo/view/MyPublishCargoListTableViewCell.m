//
//  MyPublishCargoListTableViewCell.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MyPublishCargoListTableViewCell.h"

@interface MyPublishCargoListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherInfoLabel;


@end

@implementation MyPublishCargoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setDicModel:(NSDictionary *)dicModel{
    _dicModel = dicModel;
    self.typeLabel.text = validString(dicModel[@"type"]);
    self.typeInfoLabel.text = [NSString stringWithFormat:@"共%@吨 剩%@吨",validString(dicModel[@"weight"]),validString(dicModel[@"surplus_weight"])];
    self.startLabel.text = validString(dicModel[@"loading"]);
    self.endLabel.text = validString(dicModel[@"unload"]);
    self.timeLabel.text = [NSString stringWithFormat:@"装货时间：%@",validString(dicModel[@"create_time"])];
    self.otherInfoLabel.text = [NSString stringWithFormat:@"报价：%@/吨",validString(dicModel[@"good_price"])];
}

- (NSString *) returnTimeValue:(NSString *) str{
    NSTimeInterval interval =[str doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}
@end
