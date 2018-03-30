//
//  RotOrderTableViewCell.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "RotOrderTableViewCell.h"
#import <YYKit.h>
#import "UILabel+Width.h"

@implementation RotOrderTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.canadd= YES;
        [self createCell];
    }
    return self;
}

- (void)createCell {
    [self.contentView addSubview:self.carNumlab];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.numFile];
    [self.contentView addSubview:self.checkLogo];
    UIButton * addButn = [UIButton buttonWithType:UIButtonTypeCustom];
    addButn.frame = CGRectMake(self.numFile.right - 30, self.numFile.top, 30, 20);
    [addButn setImage:[UIImage imageNamed:@"productDetail_add_enabled.png"] forState:UIControlStateNormal];
    [addButn setImage:[UIImage imageNamed:@"productDetail_add_disabled.png"] forState:UIControlStateDisabled];
    [addButn setImage:[UIImage imageNamed:@"productDetail_add_clicked.png"] forState:UIControlStateHighlighted];
    [addButn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * deleteButn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButn.frame = CGRectMake(self.numFile.left, self.numFile.top, 30, 20);
    [deleteButn setImage:[UIImage imageNamed:@"productDetail_delete_enabled.png"] forState:UIControlStateNormal];
    [deleteButn setImage:[UIImage imageNamed:@"productDetail_delete_disabled.png"] forState:UIControlStateDisabled];
    [deleteButn setImage:[UIImage imageNamed:@"productDetail_delete_clicked.png"] forState:UIControlStateHighlighted];
    [deleteButn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addButn = addButn;
    self.deleteButn = deleteButn;
    self.deleteButn.enabled = NO;
    [self.contentView addSubview:self.addButn];
    [self.contentView addSubview:self.deleteButn];
}

- (void)setModel:(RotCarinfoModel *)model {
    self.id = [model.id intValue];;
    float width = [UILabel getWidthWithTitle:model.license font:[UIFont systemFontOfSize:13]];
    [self.carNumlab setWidth:width + 10];
    self.carNumlab.text = model.license;
    self.maxNum = [model.load intValue];
}

-(void)addAction:(UIButton *)sender{
    NSString * changeStr = self.numFile.text;
    NSInteger minimumNum = 0;
    NSInteger maxNum = self.maxNum;
    if (!self.canadd) {
         self.addButn.enabled = NO;
    }
    if ([changeStr integerValue] > 0 || [changeStr integerValue] < maxNum) {
        self.numFile.text = [NSString stringWithFormat:@"%ld",[changeStr integerValue]+1];
        
        if (self.checkBlock) {
            self.checkBlock([NSString stringWithFormat:@"%d",self.num], self.check);
        }
        
        if ([self.numFile.text integerValue] == maxNum) {
            self.addButn.enabled = NO;
        }
        if ([self.numFile.text integerValue] > minimumNum) {
            self.deleteButn.enabled = YES;
        }
    }
    
}

-(void)deleteAction:(UIButton *)sender{
    NSString * changeStr = self.numFile.text;
    NSInteger minimumNum = 0;
    NSInteger maxNum = self.maxNum;
    if ([changeStr integerValue] > 0 || [changeStr integerValue] < maxNum) {
        
        self.numFile.text = [NSString stringWithFormat:@"%ld",[changeStr integerValue]-1];
        
        if (self.checkBlock) {
            self.checkBlock([NSString stringWithFormat:@"%d",self.num], self.check);
        }
        
        if ([self.numFile.text integerValue] == minimumNum) {
            self.deleteButn.enabled = NO;
        }
        if ([self.numFile.text integerValue] < maxNum) {
            self.addButn.enabled = YES;
        }
    }
}

- (UILabel *)carNumlab {
    if (!_carNumlab) {
        _carNumlab = [[UILabel alloc] initWithFrame:FRAME(15, 0, 60, 20)];
        [_carNumlab setCenterY:self.contentView.centerY + 10];
        _carNumlab.font = [UIFont systemFontOfSize:13];
        _carNumlab.backgroundColor = [UIColor yellowColor];
        _carNumlab.layer.masksToBounds = YES;
        _carNumlab.textAlignment = NSTextAlignmentCenter;
        _carNumlab.layer.borderWidth = 1;
        _carNumlab.layer.borderColor = [[UIColor blackColor] CGColor];
        _carNumlab.layer.cornerRadius = 3;
    }
    return _carNumlab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        float width = [UILabel getWidthWithTitle:@"申运重量(吨)：" font:[UIFont systemFontOfSize:13]];
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(self.carNumlab.right + 20, self.carNumlab.top, width, 20)];
        _titleLab.text =@"申运重量(吨)：";
        _titleLab.font = [UIFont systemFontOfSize:13];
    }
    return _titleLab;
}

- (UITextField *)numFile {
    if (!_numFile) {
        _numFile = [[UITextField alloc] initWithFrame:FRAME(self.titleLab.right, self.carNumlab.top, 90, 20)];
        _numFile.textAlignment = NSTextAlignmentCenter;
        _numFile.userInteractionEnabled = NO;
        _numFile.text = [NSString stringWithFormat:@"%d", self.num];
    }
    return _numFile;
}

- (UIButton *)checkLogo {
    if (!_checkLogo) {
        _checkLogo = [[UIButton alloc] initWithFrame:FRAME(kScreenW - 45, self.titleLab.top, 30, 30)];
        [_checkLogo setImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
        [_checkLogo setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateSelected];
        [_checkLogo addTarget:self action:@selector(checkLogoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkLogo;
}

- (void)checkLogoClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.check = sender.selected;
    if (self.checkBlock) {
        self.checkBlock([NSString stringWithFormat:@"%d",self.num], self.check);
    }
}

@end
