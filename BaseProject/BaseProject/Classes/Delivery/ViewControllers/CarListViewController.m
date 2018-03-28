//
//  CarListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CarListViewController.h"
#import "CarCell.h"
#import "CarFooterView.h"

NSString * const CarCellIdentifier = @"CarCellIdentifier";
@interface CarListViewController ()

@end

@implementation CarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self addLeftBarButtonWithImage:[UIImage imageNamed:@"zz"] action:@selector(backAction)];
    [self setCustomerTitle:@"发布车源"];
    [self registerCell];
    self.CC_table.bounces = NO;
}
- (BOOL)addRefreshHeader{
    return NO;
}
-(CGRect)getTableFrame{
    return CGRectMake(0, 64, kScreenW, kScreenH - 64);
}
- (UITableViewStyle )getStyle{
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([CarCell class]) bundle:nil] forCellReuseIdentifier:CarCellIdentifier];
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CarFooterView * footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CarFooterView class]) owner:nil options:nil].firstObject;
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 写这个方法防止报警告，只要子类中覆盖这个方法就不会影响显示
    UITableViewCell * cell = nil;
    CarCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CarCellIdentifier];
    
    [self configCell:tempCell withIndexPath:indexPath];
    cell = tempCell;
    return cell;
}

- (void)configCell:(CarCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSString * imageName = @"";
    NSString * title = @"";
    NSString * content = @"";
    NSString * placeholder = @"";
    
    switch (indexPath.row ) {
        case 0:{
            title =  @"空车";
            placeholder =  @"请选择空车";
        }
            break;
        case 1:{
            title =  @"起点";
            imageName = @"weizhi";
            placeholder =  @"请选择起点";
        }
            break;
        case 2:{
            title =  @"终点";
            imageName = @"weizhi";
            placeholder =  @"请选择终点";
        }
            break;
        case 3:{
            title =  @"空车位置";
            placeholder =  @"请选择空城位置";
        }
            break;
        case 4:{
            title =  @"装货时间";
            placeholder =  @"请选择装车时间";
        }
            break;
        default:
            break;
    }
 
    [cell setupImg:imageName withTitle:title withTextFeild:content withPlaceholder:placeholder];
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
