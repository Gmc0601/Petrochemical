
//
//  ChooseAddressSearchView.m
//  BaseProject
//
//  Created by DCQ on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChooseAddressSearchView.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"
@interface ChooseAddressSearchView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textfeild;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation ChooseAddressSearchView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.textfeild.delegate = self;
    self.textfeild.returnKeyType = UIReturnKeySearch;
    self.lineV.backgroundColor = UIColorFromHex(0xE3E3E3);
    //自定义 完成按钮事件
    [self.textfeild addDoneOnKeyboardWithTarget:self action:@selector(doneAction:) ];
}
- (void)doneAction:(id)sender{
    if (self.inputText ) {
        [self.textfeild resignFirstResponder];
        
        self.inputText(self.textfeild.text);
    }
 
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
