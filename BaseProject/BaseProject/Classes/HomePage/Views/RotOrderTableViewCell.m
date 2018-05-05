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
//    [self.contentView addSubview:self.checkLogo];
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
    [self.contentView addSubview:self.swi];
//    [self.contentView addSubview:self.addButn];
//    [self.contentView addSubview:self.deleteButn];
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
        _numFile = [[UITextField alloc] initWithFrame:FRAME(self.titleLab.right, self.carNumlab.top, SizeWidth(80), 20)];
        _numFile.textAlignment = NSTextAlignmentCenter;
        _numFile.font = [UIFont systemFontOfSize:17];
        _numFile.delegate = self;
        _numFile.keyboardType = UIKeyboardTypeDecimalPad;
        [_numFile setValue:[UIFont boldSystemFontOfSize:SizeWidth(17)] forKeyPath:@"_placeholderLabel.font"];
        [_numFile setValue:ThemeBlue forKey:@"_placeholderLabel.textColor"];
        _numFile.placeholder = @"点击输入";
    }
    return _numFile;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
//                    showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
//                    showMsg(@"数据格式有误");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
//                        showMsg(@"最多两位小数");
                        [ConfigModel mbProgressHUD:@"最多两位小数~" andView:nil];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            showMsg(@"数据格式有误");
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (UISwitch *)swi {
    if (!_swi) {
        _swi = [[UISwitch alloc] initWithFrame:FRAME(kScreenW - 66, self.carNumlab.top  - 6, 40, 20)];
        _swi.on = NO;
        [_swi addTarget:self action:@selector(checkLogoClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _swi;
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

- (void)checkLogoClick:(UISwitch *)sender {
    
    sender.selected = !sender.selected;
    self.check = sender.selected;
    if (self.checkBlock) {
        self.checkBlock([NSString stringWithFormat:@"%d",self.num], self.check);
    }
}

@end
