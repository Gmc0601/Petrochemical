//
//  CustomSeletedPickView.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CustomSeletedPickView.h"

@interface CustomSeletedPickView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *selectedValue;
@property (copy, nonatomic) CustomSeletedPickViewBlock  myBlock;
@end

@implementation CustomSeletedPickView

+ (void)creatCustomSeletedPickViewWithTitle:(NSString *)titleString value:(NSArray *)dataArray block:(CustomSeletedPickViewBlock)block{
    CustomSeletedPickView *customView = [[NSBundle mainBundle] loadNibNamed:@"CustomSeletedPickView" owner:self options:nil].firstObject;
    customView.frame = kScreen_BOUNDS;
    customView.titleLabel.text = titleString;
    customView.dataSource = dataArray;
    customView.pickView.delegate = customView;
    customView.pickView.dataSource = customView;
    customView.myBlock = block;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:customView];
}

- (void) awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)sureButtonAction:(id)sender {
    NSMutableDictionary *dic = @{}.mutableCopy;
    if (self.selectedValue) {
        dic = self.selectedValue;
    }else if (self.dataSource.count > 0){
        dic = self.dataSource[0];
    }
    _myBlock(dic);
    [self removeFromSuperview];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 54;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *linkNameStr = self.dataSource[row][@"linkname"];
    return linkNameStr;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    self.selectedValue = [self.dataSource[row] mutableCopy];
}
@end
