//
//  CompleteAddressViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CompleteAddressViewController.h"
#import "CompleteAddressCell.h"
#import "ChooseAddressListViewController.h"

NSString * const CompleteAddressCellIdentifier = @"CompleteAddressCellIdentifier";
@interface CompleteAddressViewController ()
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, copy) NSString * address;
@property(nonatomic, copy) NSString * detail_Address;
@property(nonatomic, copy) NSString * lat;
@property(nonatomic, copy) NSString * lon;
@property(nonatomic, copy) NSString * mobile;
@end

@implementation CompleteAddressViewController

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomerTitle:@"选择地点"];
    [self registerCell];
 
    self.CC_table.bounces = NO;
 
    [self setupBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBottomView{
    UIButton * button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:UIColorFromHex(0x028BF3)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString * buttonTitle = @"确定";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    [self.view addSubview:self.bottomView];
    [self.bottomView setFrame:CGRectMake(0, CGRectGetMaxY(self.CC_table.frame), kScreenW, 49)];
    [button setFrame:CGRectMake(0, 2, kScreenW, 45)];
    
    
}
- (void)buttonAction:(id)sender{
    
    if (self.completeAddressInfoBlock && self.address && self.detail_Address && self.lat && self.lon && self.mobile) {
        NSDictionary * info = @{@"address":self.address,@"detail":self.detail_Address,@"lat":self.lat,@"lon":self.lon,@"mobile":self.mobile};
        self.completeAddressInfoBlock( info, self.chooseIndex);
         [self.navigationController popViewControllerAnimated:YES];
    }
 
}
- (BOOL)addRefreshHeader{
    return NO;
}
-(CGRect)getTableFrame{
    return CGRectMake(0, 64, kScreenW, kScreenH - 64 - 49);
}
- (UITableViewStyle )getStyle{
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([CompleteAddressCell class]) bundle:nil] forCellReuseIdentifier:CompleteAddressCellIdentifier];
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger  row = 3;
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
 
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    header.backgroundColor = [UIColor clearColor];
    return header;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
    return footerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 写这个方法防止报警告，只要子类中覆盖这个方法就不会影响显示
    UITableViewCell * cell = nil;
    CompleteAddressCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CompleteAddressCellIdentifier];
    [self confightCell:tempCell withIndexPath:indexPath];
    cell = tempCell;
    return cell;
}

- (void)confightCell:(CompleteAddressCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    NSString * title = @"";
    NSString * content = @"";
    NSString * placeholder = @"";
    BOOL enabled = NO;
    UIKeyboardType  type  = UIKeyboardTypeDefault;
    if (indexPath.row == 0) {
       title = @"地点名称";
        if (self.address) {
            content = self.address;
        }
     
        placeholder = @"请选择地点名称";
    }
    if (indexPath.row == 1) {
         title = @"详细地址";
        if (self.detail_Address) {
           content = self.detail_Address;
        }
         placeholder = @"请填写具体单元号、楼层等";
        enabled = YES;
    }
    if (indexPath.row == 2) {
        title = @"联系电话";
        if (self.mobile) {
            content = self.mobile;
        }
        type  = UIKeyboardTypeNumberPad;
        placeholder = @"请填写联系电话";
         enabled = YES;
    }
    cell.row = indexPath.row ;
    cell.inputTextBlock = ^(NSString *inputText, NSInteger row) {
        if (indexPath.row == 1) {
            self.detail_Address = inputText;
        }else  if (indexPath.row == 2) {
            self.mobile = inputText ;
        }
  
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupTFEnabled:enabled withKeyboardType:type];
    [cell setupTitle:title withTextFeild:content withPlaceholder:placeholder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self gotoChooseAddress];
    }
    
}
- (void)gotoChooseAddress{
    
    ChooseAddressListViewController * addressVC = [[ChooseAddressListViewController alloc]init];

    if (self.chooseType == CompleteAddressType_loading) {
        addressVC.chooseType = ChooseAddressType_loading;
    }else if (self.chooseType == CompleteAddressType_unLoading){
        addressVC.chooseType = ChooseAddressType_unLoading;
    }
    addressVC.chooseAddressInfoBlock = ^(NSDictionary *addressInfo,NSInteger chooseIndex) {
        self.address = addressInfo[@"name"];
        self.lat  =[NSString stringWithFormat:@"%@",addressInfo[@"latitude"]];
        self.lon = [NSString stringWithFormat:@"%@",addressInfo[@"longitude"]];
        [self.CC_table reloadData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];

}
@end
