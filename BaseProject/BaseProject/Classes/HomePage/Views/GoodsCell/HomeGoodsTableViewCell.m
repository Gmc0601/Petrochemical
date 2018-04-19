//
//  HomeGoodsTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/4/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HomeGoodsTableViewCell.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>
#import "TimeManage.h"

@implementation HomeGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lumingLogo];
        [self.contentView addSubview:self.startLab];
        [self.contentView addSubview:self.toLogo];
        [self.contentView addSubview:self.endLab];
//        [self.contentView addSubview:self.locaLogo];
        [self.contentView addSubview:self.locationLab];
        [self.contentView addSubview:self.headimage];
        [self.contentView addSubview:self.nickLabLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.callLogo];
    }
    return self;
}

- (void)setModel:(HomeGoodsModel *)model {
    
//    NSString *data = [NSString stringWithFormat:@"%@", model.use_time];
//    NSString *str = [TimeManage getToday:data];
//    if ([str isEqualToString:@"今天"]) {
//        self.backgroundColor = UIColorFromHex(0xE5F7E3);
//    }else if ([str isEqualToString:@"昨天"]){
//        self.backgroundColor = UIColorFromHex(0xF5F7E3);
//    }else {
//        self.backgroundColor = [UIColor whiteColor];
//    }
    self.startLab.text = model.loading;
    self.endLab.text = model.unload;
    self.locationLab.text = [NSString stringWithFormat:@"运费:%@元", model.transportation];
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    self.nickLabLab.text = model.linkname;
    self.timeLab.text = [NSString stringWithFormat:@"用车时间：%@", model.use_time];
    if ([model.is_plat intValue] == 1) {
        //  显示
        [self.lumingLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(40);
        }];
        
        [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lumingLogo.mas_right).offset(5);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }else {
        //  不显示
        [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.height.mas_equalTo(20);
        }];
        
    }
    UIImage *to= [UIImage imageNamed:@"xiangyou"];
    [self.toLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startLab.mas_right).offset(5);
        make.centerY.equalTo(self.startLab.mas_centerY);
        make.height.mas_equalTo(to.size.height);
        make.width.mas_equalTo(to.size.width);
    }];
    
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toLogo.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    //  添加分类  #a666c7，#78a1e3，#b4cc44   [NSString stringWithFormat:@"%@ 共%@吨,剩%@吨", model.type, model.weight, model.surplus_weight];
    UILabel *tag1 = [self createLabtext:model.type colot:UIColorFromHex(0xa666c7)];
    [self.contentView addSubview:tag1];
    
    [tag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.endLab.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *tag2 = [self createLabtext:[NSString stringWithFormat:@"共%@吨", model.weight] colot:UIColorFromHex(0x78a1e3)];
    [self.contentView addSubview:tag2];
    [tag2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tag1.mas_right).offset(10);
        make.top.equalTo(self.endLab.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *tag3 = [self createLabtext:[NSString stringWithFormat:@"剩%@吨", model.weight] colot:UIColorFromHex(0xb4cc44)];
    [self.contentView addSubview:tag3];
    [tag3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tag2.mas_right).offset(10);
        make.top.equalTo(self.endLab.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    //  运费
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(tag1.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.locationLab.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.nickLabLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headimage.mas_right).offset(5);
        make.top.equalTo(self.locationLab.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickLabLab.mas_right).offset(5);
        make.top.equalTo(self.locationLab.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.callLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

- (UILabel *)createLabtext:(NSString *)text colot:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = text;
    lab.textColor = color;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 5;
    lab.layer.borderWidth = 1;
    lab.layer.borderColor = [color CGColor];
    lab.font = [UIFont systemFontOfSize:12];
    return lab;
}

- (UIImageView *)lumingLogo {
    if (!_lumingLogo) {
        _lumingLogo = [[UIImageView alloc] init];
        _lumingLogo.backgroundColor = [UIColor clearColor];
        _lumingLogo.image = [UIImage imageNamed:@"luming"];
    }
    return _lumingLogo;
}

- (UILabel *)startLab {
    if (!_startLab) {
        _startLab = [[UILabel alloc] init];
        _startLab.backgroundColor = [UIColor clearColor];
        _startLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _startLab;
}

- (UIImageView *)toLogo {
    if (!_toLogo) {
        _toLogo = [[UIImageView alloc] init];
        _toLogo.backgroundColor = [UIColor clearColor];
        _toLogo.image = [UIImage imageNamed:@"xiangyou"];
    }
    return _toLogo;
}

- (UILabel *)endLab {
    if (!_endLab) {
        _endLab = [[UILabel alloc] init];
        _endLab.backgroundColor = [UIColor clearColor];
        _endLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _endLab;
}

- (UIImageView *)locaLogo {
    if (!_locaLogo) {
        _locaLogo = [[UIImageView alloc] init];
        _locaLogo.backgroundColor = [UIColor clearColor];
        _locaLogo.image = [UIImage imageNamed:@"weizhi"];
    }
    return _locaLogo;
}

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] init];
        _locationLab.backgroundColor = [UIColor clearColor];
        _locationLab.textColor = ThemeBlue;
        _locationLab.font = [UIFont systemFontOfSize:14];
    }
    return _locationLab;
}

- (UIImageView *)headimage {
    if (!_headimage) {
        _headimage = [[UIImageView alloc] init];
        _headimage.backgroundColor = RGBColor(239, 240, 241);
        _headimage.layer.masksToBounds = YES;
        _headimage.layer.cornerRadius = 10;
        _headimage.layer.borderWidth = 1;
        _headimage.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _headimage;
}

- (UILabel *)nickLabLab {
    if (!_nickLabLab) {
        _nickLabLab = [[UILabel alloc] init];
        _nickLabLab.backgroundColor = [UIColor clearColor];
        _nickLabLab.textColor = UIColorFromHex(0x666666);
        _nickLabLab.backgroundColor = [UIColor clearColor];
        _nickLabLab.font = [UIFont systemFontOfSize:13];
    }
    return _nickLabLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = UIColorFromHex(0x666666);
        _timeLab.font = [UIFont systemFontOfSize:13];
    }
    return _timeLab;
}

- (UIImageView *)callLogo {
    if (!_callLogo) {
        _callLogo = [[UIImageView alloc] init];
        _callLogo.backgroundColor = [UIColor clearColor];
        _callLogo.image = [UIImage imageNamed:@"call"];
    }
    return _callLogo;
}


@end
