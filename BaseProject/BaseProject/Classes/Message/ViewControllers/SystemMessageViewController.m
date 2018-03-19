//
//  SystemMessageViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "InformationDetailViewController.h"
@interface SystemMessageViewController ()
@property (nonatomic,strong) NSArray *listArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"系统通知"];
    self.listArray = @[@{}];
    [self.tableView reloadData];
    [self addRightBarButtonItemWithTitle:@"清空" action:@selector(clickCleanAll:) color:RGBColor(36,36,36)];
    // Do any additional setup after loading the view from its nib.
}

-(void)clickCleanAll:(UIButton *)sender{
    
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = [self.listArray objectAtIndex:indexPath.row];
    
    NSString *cellStr = @"SystemMessageTableViewCell";
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SystemMessageTableViewCell" owner:nil options:nil][0];
    }
    [cell setData:dataDic];
    return cell;
    
    
}

#pragma mark--UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationDetailViewController *con = [[InformationDetailViewController alloc] init];
    //  NSDictionary *dataDic = self.listArray[indexPath.row];
    //  con.orderId = dataDic[@"id"];
    [self.navigationController pushViewController:con animated:YES];
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
