//
//  RobOrderViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "RobOrderViewController.h"
#import "RotOrderTableViewCell.h"
#import "RotCarinfoModel.h"
#import "RotOrderviewmodel.h"
#import <YYKit.h>

@interface RobOrderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    float maxWigth;
    float addWigth;
}

@property (nonatomic, strong) UITableView *noUseTableView;

@property (nonatomic, strong) NSArray *dateArr, *titleArr;

@property (nonatomic, strong)RotOrderviewmodel *viewmodel;

@property (nonatomic, strong) UILabel *blanceLab;

@property (nonatomic, strong) NSMutableArray *addArr;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation RobOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"抢单"];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.commitBtn];
    [self raccommand];
}

- (void)raccommand {
    [[self.viewmodel.carinfoCommand execute:@"carinfo"] subscribeNext:^(NSArray * x) {
        self.dateArr = x;
        maxWigth = [self.balance floatValue];
        [self.noUseTableView reloadData];
    }];
}

- (void)commitCommad {
    if (!self.viewmodel.json) {
        [ConfigModel mbProgressHUD:@"请选择使用车量" andView:nil];
        return;
    }
    
    [[self.viewmodel.rotOrderCommand execute:@"rotOrder"] subscribeNext:^(NSString * x) {
        NSLog(@"<><>%@",x);
        if ([x isEqualToString:@"success"]) {
            [ConfigModel mbProgressHUD:@"抢单信息已通过短信方式发送给货主，请耐心等待货主与您联系!" andView:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString*cellId = [NSString stringWithFormat:@"%lu%lu", indexPath.section, indexPath.row];
    
        RotOrderTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[RotOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dateArr[indexPath.row];
    cell.checkBlock = ^(NSString * num, BOOL check) {
        addWigth = 0; [self.addArr removeAllObjects];
        for (int row = 0; row < self.dateArr.count  ; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            RotOrderTableViewCell *cell = [self.noUseTableView cellForRowAtIndexPath:indexPath];
            
            if (cell.check) {
                if ((addWigth + [cell.numFile.text floatValue]) <= [self.balance floatValue]) {
                    addWigth += [cell.numFile.text floatValue];
                    NSString *key = [NSString stringWithFormat:@"%d", cell.id];
                    NSString *velau = cell.numFile.text;
                    NSDictionary *dic = @{
                                          @"car_id" :key,
                                          @"rough_weight" :velau
                                          };
                    [self.addArr addObject:dic];
                    NSError *error = nil;
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.addArr
                                                                       options:kNilOptions
                                                                         error:&error];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                                 encoding:NSUTF8StringEncoding];
                    self.viewmodel.json = jsonString;
                    self.viewmodel.grab_weight = [NSString stringWithFormat:@"%.2f", addWigth];
                    if (addWigth == [self.balance intValue]) {
                        for (int row = 0; row < self.dateArr.count  ; row++) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                            RotOrderTableViewCell *cell = [self.noUseTableView cellForRowAtIndexPath:indexPath];
                            if (cell.check) {
                                cell.canadd = NO;
                                cell.addButn.enabled = NO;
                            }
                        }
                    }
                    
                }else {
                    cell.checkLogo.selected = NO;
                    cell.check = NO;
                    [ConfigModel mbProgressHUD:@"没有更多数量可抢" andView:nil];
                }
                
            }else {
                cell.canadd = YES;

            }
            
            
        }
        self.blanceLab.text = [NSString stringWithFormat:@"%.2f", addWigth];
        
    };
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  130;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, kScreenW , 130)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addheadView:headerView];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50 - [StatusBar floatValue] - [NavbarHeight floatValue]) style:UITableViewStylePlain];
        _noUseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
    }
    return _noUseTableView;
}


- (void)addheadView:(UIView *)view {
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:FRAME(15, 25, kScreenW/2, 15)];
    lab1.text = @"抢单数量吨";
    [view addSubview:lab1];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/3, 25, kScreenW/3 * 2 - 15, 15)];
    lab.textColor= UIColorFromHex(0xcccccc);
    lab.textAlignment = NSTextAlignmentRight;
    lab.text = [NSString stringWithFormat:@"剩余可抢数量%@吨",self.balance];
    [view addSubview:lab];
    self.blanceLab = lab;
    
    UILabel *line = [[UILabel alloc] initWithFrame:FRAME(15, 65, kScreenW, 0.5)];
    line.backgroundColor = UIColorFromHex(0xcccccc);
    [view addSubview:line];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:FRAME(15, 65+25, kScreenW/2, 15)];
    lab2.text = @"选择做单罐车";
    [view addSubview:lab2];
    
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr  = @[@"抢单数量(吨)", @"选择做单罐车"];
    }
    return _titleArr;
}

- (RotOrderviewmodel *)viewmodel {
    if (!_viewmodel) {
        _viewmodel = [[RotOrderviewmodel alloc] init];
        _viewmodel.good_num = self.good_num;
    }
    return _viewmodel;
}

- (NSMutableArray *)addArr {
    if (!_addArr) {
        _addArr = [[NSMutableArray alloc] init];
    }
    return _addArr;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:FRAME(0, self.noUseTableView.bottom + 1, kScreenW, 50)];
        _commitBtn.backgroundColor = ThemeBlue;
        [_commitBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitCommad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end

