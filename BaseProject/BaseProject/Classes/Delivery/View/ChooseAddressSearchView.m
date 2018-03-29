
//
//  ChooseAddressSearchView.m
//  BaseProject
//
//  Created by DCQ on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChooseAddressSearchView.h"
@interface ChooseAddressSearchView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textfeild;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation ChooseAddressSearchView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.textfeild.delegate = self;
    self.lineV.backgroundColor = UIColorFromHex(0xE3E3E3);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = YES;
    if (self.inputText) {
        [textField resignFirstResponder];
        self.inputText(textField.text);
    }
    return flag;
}

- (void)setupArea:(NSString *)area{
    [self.btn setTitle:area forState:UIControlStateNormal];
}
- (IBAction)btnAction:(id)sender {
    if (self.areaBlock) {
        self.areaBlock();
    }
}

@end
