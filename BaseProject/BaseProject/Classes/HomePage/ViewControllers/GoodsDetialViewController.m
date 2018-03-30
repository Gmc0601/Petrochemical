//
//  GoodsDetialViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsDetialViewController.h"
#import "GoodsDetialviewmodel.h"
#import "GoodsDetailModel.h"
#import "GoodsDetailModel.h"
#import <YYKit.h>
#import "FeailView.h"
#import "RobOrderViewController.h"

@interface GoodsDetialViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *noUseTableView;

@property (nonatomic, strong) NSMutableArray *titleArr, *detialArr;

@property (nonatomic, strong) GoodsDetialviewmodel *viewmodel;

@property (nonatomic, strong) GoodsDetailModel *model;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) YYTextView *text;


@end

@implementation GoodsDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"货源详情"];
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.commitBtn];
    [self raccomand];
}

- (void)raccomand {
    [[self.viewmodel.goodDetialCommand execute:@"goodDetial"] subscribeNext:^(GoodsDetailModel * model) {
        self.model = model;
        NSArray *arr = model.xiehuo;
        for (int i = 0; i < arr.count; i++) {
            [self.titleArr insertObject:@"卸货点" atIndex:2];
        }
        NSDictionary *dic = @{@"loading" : self.model.loading,
                              @"loading_address" : self.model.loading_address
                              };
        NSArray *dearr =  @[self.model.good_num, self.model.mileage, self.model.use_time,self.model.type, self.model.weight, self.model.good_price, self.model.cost, self.model.account_type];
        self.detialArr = [[NSMutableArray alloc] initWithArray:dearr];
        [self.detialArr insertObject:dic atIndex:1];
        self.text.text = self.model.remark;
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            NSString *unload = dic[@"unload"];
            NSString *unload_address = dic[@"unload_address"];
            NSDictionary *dicinfo = @{@"unload" : unload, @"unload_address" : unload_address};
            [self.detialArr insertObject:dicinfo atIndex:2+i];
        }
        [self.noUseTableView reloadData];
        
        if ([self.model.indent_type intValue] == 1) {
            //  已抢
            self.commitBtn.backgroundColor = [UIColor grayColor];
            self.commitBtn.userInteractionEnabled = NO;
        }
        if ([self.model.user_type intValue] == 1) {
            [self.commitBtn setTitle:@"管理我的货源" forState:UIControlStateNormal];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSString *cellId = [NSString stringWithFormat:@"%lu", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    if ([self.detialArr[indexPath.row] isKindOfClass:[NSString class]]) {
      cell.detailTextLabel.text = self.detialArr[indexPath.row];
    }
    if ([cell.textLabel.text isEqualToString:@"装货点"]) {
        NSDictionary *dic = self.detialArr[indexPath.row];
        NSString *title = dic[@"loading"];
        NSString *sub = dic[@"loading_address"];
        cell.imageView.image = [UIImage imageNamed:@"icon_txddz"];
        [cell.imageView sizeToFit];
        UILabel *titlelab = [[UILabel alloc] initWithFrame:FRAME( 95, 5, kScreenW - 60 - 50, 20)];
        titlelab.font = [UIFont systemFontOfSize:15];
        titlelab.textAlignment = NSTextAlignmentRight;
        titlelab.text = title;
        [cell.contentView addSubview:titlelab];
        UILabel *subLab = [[UILabel alloc] initWithFrame:FRAME(95, 25, kScreenW -60 - 50, 20)];
        subLab.textColor = [UIColor grayColor];
        subLab.font = [UIFont systemFontOfSize:13];
        subLab.textAlignment = NSTextAlignmentRight;
        subLab.text = sub;
        [cell.contentView addSubview:subLab];
        
    }
    if ([cell.textLabel.text isEqualToString:@"卸货点"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_nxddz"];
        [cell.imageView sizeToFit];
        NSDictionary *dic = self.detialArr[indexPath.row];
        NSString *title = dic[@"unload"];
        NSString *sub = dic[@"unload_address"];
        UILabel *titlelab = [[UILabel alloc] initWithFrame:FRAME( 95, 5, kScreenW - 60 - 50, 20)];
        titlelab.font = [UIFont systemFontOfSize:15];
        titlelab.textAlignment = NSTextAlignmentRight;
        titlelab.text = title;
        [cell.contentView addSubview:titlelab];
        UILabel *subLab = [[UILabel alloc] initWithFrame:FRAME(95, 25, kScreenW -60 - 50, 20)];
        subLab.textColor = [UIColor grayColor];
        subLab.font = [UIFont systemFontOfSize:13];
        subLab.textAlignment = NSTextAlignmentRight;
        subLab.text = sub;
        [cell.contentView addSubview:subLab];
    }
    
    
    return cell;
    
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UILabel *line = [[UILabel alloc] initWithFrame:FRAME(15, 0, kScreenW , 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
            UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(15, 15, kScreenW , 15)];
            lab.text = @"货主备注";
            [view addSubview:line];
            [view addSubview:lab];
            self.text = [[YYTextView alloc] initWithFrame:FRAME(15, 30, kScreenW - 30, 30)];
            self.text.placeholderText = @"暂无备注";
            self.text.textColor = [UIColor grayColor];
            self.text.font = [UIFont systemFontOfSize:13];
            self.text.userInteractionEnabled = NO;
            [view addSubview:self.text];
            
            //   添加货主备注
            view;
        });
    }
    return _noUseTableView;
}


- (GoodsDetialviewmodel *)viewmodel {
    if (!_viewmodel) {
        _viewmodel =[[GoodsDetialviewmodel alloc] init];
        _viewmodel.id = self.idStr;
    }
    return _viewmodel;
}

- (GoodsDetailModel *)model {
    if (!_model) {
        _model = [[GoodsDetailModel alloc] init];
    }
    return _model;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:FRAME(0, kScreenH - 50, kScreenW, 50)];
        [_commitBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
        _commitBtn.backgroundColor = ThemeBlue;
        [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (void)commitClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"管理我的货源"]) {
        
    }
    if ([sender.titleLabel.text isEqualToString:@"立即抢单"]) {
        FeailView *view = [[FeailView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        view.clickBlick = ^{
            RobOrderViewController *vc = [[RobOrderViewController alloc] init];
            vc.good_num = self.model.good_num;
            vc.balance = self.model.surplus_weight;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [view pop];
    }
    
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        NSArray *arr = @[@"货单号",@"装货点", @"预计里程", @"用车时间", @"货物名称", @"货物重量", @"运输单价", @"运输费", @"结算方式"];
        _titleArr = [[NSMutableArray alloc] initWithArray:arr];
    }
    return _titleArr;
}



@end
