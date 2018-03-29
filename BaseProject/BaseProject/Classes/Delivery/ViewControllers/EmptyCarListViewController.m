
//
//  EmptyCarListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "EmptyCarListViewController.h"
#import "EmptyCarCell.h"

NSString * const EmptyCarCellIdentifier = @"EmptyCarCellIdentifier";
@interface EmptyCarListViewController ()
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, assign) NSInteger   selectedIndx;
@property(nonatomic, strong) NSArray * emptyCars;
 @property(nonatomic, strong) UILabel * emptyLabel;
@end

@implementation EmptyCarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomerTitle:@"选择空车"];
    [self registerCell];
    self.CC_table.bounces = NO;
    self.selectedIndx = -1;
    [self setupBottomView];
    [self.view addSubview:self.emptyLabel];
    [self requestEmpty];
    
}

- (UILabel *)emptyLabel{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
        _emptyLabel.center = self.view.center;
        _emptyLabel.text = @"暂无数据";
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:15];
        _emptyLabel.textColor = UIColorFromHex(0x242424);
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}
- (void)requestEmpty{
    
    NSDictionary *dic = @{
                          @"userToken":@"02c8f878c1d5463b5bea89e893cde184",
                          };
    
     WeakSelf(weakself);
    [HttpRequest postPath:@"_user_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
  
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            NSArray *infoDic = dic[@"info"];
            weakself.emptyCars = infoDic;
            
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        if ([weakself.emptyCars count] >0) {
            weakself.bottomView.hidden = NO;
            weakself.emptyLabel.hidden = YES;
            weakself.CC_table.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - 49);
        }else{
             weakself.bottomView.hidden = YES;
             weakself.emptyLabel.hidden = NO;
             weakself.CC_table.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 );
        }
    }];
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
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([EmptyCarCell class]) bundle:nil] forCellReuseIdentifier:EmptyCarCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.emptyCars count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView HeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 写这个方法防止报警告，只要子类中覆盖这个方法就不会影响显示
    UITableViewCell * cell = nil;
    EmptyCarCell * tempCell = [tableView dequeueReusableCellWithIdentifier:EmptyCarCellIdentifier];
    
    [self configCell:tempCell withIndexPath:indexPath];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configCell:(EmptyCarCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * info = self.emptyCars[indexPath.section];
     NSString * name = info[@"car_name"];
     NSString * carNum = info[@"license"];
     NSString * maxLoding = info[@"load"];
     BOOL isSelected = NO;
    if (indexPath.section == self.selectedIndx) {
        isSelected = YES;
    }
    [cell setupName: name withCarNum:carNum withMaxLoding:maxLoding withSelected:isSelected];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     self.selectedIndx = indexPath.section;
    [self.CC_table reloadData];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
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
    
    if (self.emptyCarBlock && [self.emptyCars count] > 0) {
        self.emptyCarBlock(self.emptyCars[self.selectedIndx]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
