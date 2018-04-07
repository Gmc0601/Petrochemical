//
//  GoodsListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GoodsListViewController.h"
#import "CityPickerVeiw.h"
#import "CityNameModel.h" //省市区模型
#import "ZSAnalysisClass.h"  // 数据转模型类
#import "AddUnloadCell.h"
#import "GoodsUnloadingCell.h"
#import "GoodsInfoCell.h"
#import "GoodsNoteCell.h"
#import "ChooseAddressListViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "GoodsChooseView.h"

NSString * const GoodsUnloadingCellIdentifier = @"GoodsUnloadingCellIdentifier";
NSString * const AddUnloadCellIdentifier = @"AddUnloadCellIdentifier";
NSString * const GoodsInfoCellIdentifier = @"GoodsInfoCellIdentifier";
NSString * const GoodsNoteCellIdentifier = @"GoodsNoteCellIdentifier";
@interface GoodsListViewController ()
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, assign) NSInteger  unlodingNum;
@property(nonatomic, copy) NSString * startLoaction;
@property(nonatomic, strong) NSNumber * startLatitude;
@property(nonatomic, strong) NSNumber * startLongitude;
@property(nonatomic, strong) NSMutableArray * unloadingArray;
@property(nonatomic, assign) CGFloat totalDistance;
@property(nonatomic, copy) NSString *loadingTime;
@property(nonatomic, copy) NSString *weight;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *paymentMethod;
@property(nonatomic, copy) NSString *goodsId;//货物的id
@property(nonatomic, copy) NSString *goodsName;//货物的名字
@property(nonatomic, strong) NSArray *selectedGoodsIndexs;
@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomerTitle:@"发布货源"];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"zz"] action:@selector(backAction)];
    [self registerCell];
    self.unlodingNum = 1;
    [self.unloadingArray addObject:@{}];
    self.CC_table.bounces = NO;
    self.paymentMethod = @"线下结算";
    [self setupBottomView];
    
}
- (NSMutableArray *)unloadingArray{
    if (!_unloadingArray) {
        _unloadingArray = [[NSMutableArray alloc]init];
    }
    return _unloadingArray;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsUnloadingCell class]) bundle:nil] forCellReuseIdentifier:GoodsUnloadingCellIdentifier];
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([AddUnloadCell class]) bundle:nil] forCellReuseIdentifier:AddUnloadCellIdentifier];
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:GoodsInfoCellIdentifier];
    [self.CC_table registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsNoteCell class]) bundle:nil] forCellReuseIdentifier:GoodsNoteCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger  row = 0;
    if (section == 0) {
        row = 2 +  self.unlodingNum;
    }else{
        row = 7;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    if (indexPath.section == 1 && indexPath.row == 6) {
        height = 200;
    }
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
    if (indexPath.section == 0) {
        if (indexPath.row < self.unlodingNum + 2 -1) {
            GoodsUnloadingCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsUnloadingCellIdentifier];
            [self configCell:tempCell withIndexPath:indexPath];
            cell = tempCell;
        }else{
            AddUnloadCell * tempCell = [tableView dequeueReusableCellWithIdentifier:AddUnloadCellIdentifier];
            tempCell.addUnloadingBlock = ^{
                self.unlodingNum ++;
                [self.unloadingArray addObject:@{}];
                [self.CC_table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.unlodingNum inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            };
            cell = tempCell;
            
        }
        
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 6) {
            GoodsNoteCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsNoteCellIdentifier];
            
            cell = tempCell;
        }else{
            GoodsInfoCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCellIdentifier];
            [self configInfoCell:tempCell withIndexPath:indexPath];
            cell = tempCell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configInfoCell:(GoodsInfoCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    NSString * title = @"";
    NSString * content = @"";
    NSString * placeholder = @"";
    UIKeyboardType keyType = UIKeyboardTypeDefault;
    switch (indexPath.row) {
        case 0:
        {
            title = @"预计车程";
            placeholder = @"";
            if (self.totalDistance >0) {
                content = [NSString stringWithFormat:@"%0.2f公里/%0.1f小时",self.totalDistance,self.totalDistance/60];
            }else
                content = @"0公里/0小时";
        }
            break;
        case 1:
        {
            title = @"用车时间";
            placeholder = @"请选择用车时间";
            if (self.loadingTime) {
                content = self.loadingTime;
            }
            
        }
            break;
        case 2:
        {
            title = @"货物名称";
            placeholder = @"请选择货物类型";
            if (self.goodsName) {
                content = self.goodsName;
            }
            
        }
            break;
        case 3:
        {
            title = @"货物重量（吨）";
            placeholder = @"请选择货物重量";
            content = @"";
            keyType = UIKeyboardTypeNumberPad;
        }
            break;
        case 4:
        {
            title = @"运输单价（元/吨）";
            placeholder = @"请填写运输单价";
            content = @"";
            keyType = UIKeyboardTypeNumberPad;
        }
            break;
        case 5:
        {
            title = @"结算方式";
            placeholder = @"";
            content = @"线下结算";
        }
            break;
            
        default:
            break;
    }
    if (indexPath.row == 3||indexPath.row == 4) {
        [cell setupTFEnabled:YES withKeyboardType:keyType];
        cell.row = indexPath.row;
        WeakSelf(weakSelf);
        cell.inputTextBlock = ^(NSString *inputText,NSInteger row) {
            if (row == 3) {
                //重量
                weakSelf.weight = inputText;
            }else if (row == 4){
                //单价
                weakSelf.price = inputText;
            }
            
        };
    }else{
        [cell setupTFEnabled:NO withKeyboardType:keyType];
    }
    [cell setupTitle:title withTextFeild:content withPlaceholder:placeholder];
}
- (void)configCell:(GoodsUnloadingCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    BOOL  isHidden = NO;
    NSString * title = @"";
    NSString * content = @"";
    NSString * placeholder = @"";
    if (indexPath.row == 0) {
        title = @"装货点";
        placeholder = @"请选择装货点";
        if (self.startLoaction) {
            content = self.startLoaction;
        }
        
        isHidden = YES;
    }else if(indexPath.row < 2+ self.self.unlodingNum -1&& indexPath.row >0){
        
        if (indexPath.row == 1) {
            isHidden = YES;
        }else{
            isHidden = NO;
            cell.indexPath = indexPath;
            
            cell.delUnloadingBlock = ^(NSIndexPath *indexPath) {
                self.unlodingNum--;
                // 删除对应的数据 indexPath.row
                [self.unloadingArray removeObjectAtIndex:indexPath.row-1];
                [self expecteDrive];
                [self.CC_table reloadData];
            };
        }
        title = @"卸货点";
        placeholder = @"请选择卸货点";
        if ([self.unloadingArray count] >0) {
            
            NSDictionary * info = self.unloadingArray[indexPath.row-1];
            if (info) {
                content = info[@"name"];
            }
        }else{
            content = @"";
            
        }
    }
    [cell setupDelHidden:isHidden];
    [cell setupTitle:title withTextFeild:content withPlaceholder:placeholder];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self  gotoStartLoaction];
        }else if (indexPath.row < 2-1 +self.unlodingNum){
            [self gotoUnloadLoaction:indexPath];
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            [self showTimerPicker];
        }else if (indexPath.row == 2){
            [self gotoShowGoodsType];
        }
        
    }
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
    NSString * buttonTitle = @"立即发布";
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    [self.view addSubview:self.bottomView];
    [self.bottomView setFrame:CGRectMake(0, CGRectGetMaxY(self.CC_table.frame), kScreenW, 49)];
    [button setFrame:CGRectMake(0, 2, kScreenW, 45)];
    
    
}
- (void)buttonAction:(id)sender{
    [self sendCarInfo];
}


- (void)sendCarInfo{
    NSDictionary *dic = nil;
    //    if (self.car_id && self.startLocation&&self.endLocation&&self.emptyLocation&&self.lon&&self.lat&& self.loadingTime) {
    //        dic = @{
    //                @"userToken":@"02c8f878c1d5463b5bea89e893cde184",
    //                @"car_id":self.car_id,
    //                @"origin":self.startLocation,
    //                @"destination":self.endLocation,
    //                @"empty":self.emptyLocation,
    //                @"lon":[NSString stringWithFormat:@"%f",self.lon],
    //                @"lat":[NSString stringWithFormat:@"%f",self.lat],
    //                @"loading_time":self.loadingTime,
    //                //                          @"load":self.maxLoad,
    //                @"issue_type":@"1",//发布车源1  发布货源2
    //                };
    //
    //
    //    }
    //    if (!dic) {
    //        return;
    //    }
    //    WeakSelf(weakself);
    //    [HttpRequest postPath:@"_issue_car_001" params:dic resultBlock:^(id responseObject, NSError *error) {
    //
    //        NSDictionary *dic = responseObject;
    //
    //        int errorint = [dic[@"error"] intValue];
    //        if (errorint == 0 ) {
    //            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发布车源成功" preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                [weakself backAction];
    //            }];
    //            [alertVC addAction:okAction1];
    //            [self presentViewController:alertVC animated:YES completion:nil];
    //        }else {
    //            NSString *errorStr = dic[@"info"];
    //            NSLog(@"%@", errorStr);
    //            [ConfigModel mbProgressHUD:errorStr andView:nil];
    //        }
    //
    //    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showTimerPicker  {
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] initWithFrame:CGRectZero withType:PickerViewType_timer];
    cityView.col = 3;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
        self.loadingTime = value;
        [self.CC_table reloadData];
    }];
}



- (void)gotoStartLoaction{
    
    ChooseAddressListViewController * addressVC = [[ChooseAddressListViewController alloc]init];
    addressVC.chooseType = ChooseAddressType_loading;
    WeakSelf(weakSelf);
    addressVC.chooseAddressInfoBlock = ^(NSDictionary *addressInfo,NSInteger chooseIndex) {
        weakSelf.startLoaction = addressInfo[@"name"];
        weakSelf.startLatitude = addressInfo[@"latitude"];
        weakSelf.startLongitude = addressInfo[@"longitude"];
        [weakSelf.CC_table reloadData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)gotoUnloadLoaction:(NSIndexPath *)indexPath{
    
    ChooseAddressListViewController * addressVC = [[ChooseAddressListViewController alloc]init];
    addressVC.chooseIndex = indexPath.row;
    addressVC.chooseType = ChooseAddressType_unLoading;
    addressVC.chooseAddressInfoBlock = ^(NSDictionary *addressInfo,NSInteger chooseIndex) {
        
        if ([self.unloadingArray count] >= chooseIndex &&self.unloadingArray[chooseIndex-1]) {
            [self.unloadingArray replaceObjectAtIndex:chooseIndex-1 withObject:addressInfo];
        }else{
            [self.unloadingArray addObject:addressInfo];
        }
        [self expecteDrive];
        [self.CC_table reloadData];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}
//预计车程
- (void)expecteDrive{
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.startLatitude floatValue],[self.startLongitude floatValue]));
    MAMapPoint point2;
    CLLocationDistance distance  = 0;
    for (NSDictionary * info in self.unloadingArray) {
        NSNumber * latitude =info[@"latitude"];
        NSNumber * longitude = info[@"longitude"];
        point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([latitude floatValue],[longitude floatValue]));
        //2.计算总距离
        distance = distance + MAMetersBetweenMapPoints(point1,point2);
        point1 = point2;
    }
    self.totalDistance = distance/1000;
    
    
}

//选择货物
- (void)gotoShowGoodsType{
    NSDictionary * dic = @{};
    WeakSelf(weakself);
    [HttpRequest postPath:@"_classify_001" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        int errorint = [dic[@"error"] intValue];
        if (errorint == 0 ) {
            [weakself showGoodsChooseView:dic[@"info"]];
        }else {
            NSString *errorStr = dic[@"info"];
            NSLog(@"%@", errorStr);
            [ConfigModel mbProgressHUD:errorStr andView:nil];
        }
        
    }];
    
}

- (void)showGoodsChooseView:(NSArray *)goodsArray{
    GoodsChooseView * goodsView = [[GoodsChooseView alloc]initWithFrame:CGRectZero withArray:goodsArray withSelectedGoodsIndex:self.selectedGoodsIndexs];
    WeakSelf(weakSelf);
    goodsView.chooseBlock = ^(NSArray *selectedArray) {
        weakSelf.goodsName = @"";
        weakSelf.goodsId = @"";
        for (int i = 0;i<[selectedArray count];i++) {
            NSIndexPath *indexPath = selectedArray[i];
            NSDictionary * goodsInfo = goodsArray[indexPath.row];
            NSString * tempId = [NSString stringWithFormat:@"%@%@", i==0?@"":@",",goodsInfo[@"id"]];
            NSString * tempGoodsName = [NSString stringWithFormat:@"%@%@",i==0?@"":@",",goodsInfo[@"type"]];
            weakSelf.goodsId = [weakSelf.goodsId stringByAppendingString:tempId];
            weakSelf.goodsName = [weakSelf.goodsName stringByAppendingString:tempGoodsName];
        }
        weakSelf.selectedGoodsIndexs = selectedArray;
        [weakSelf.CC_table reloadData];
    };
    [goodsView show];
    
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

