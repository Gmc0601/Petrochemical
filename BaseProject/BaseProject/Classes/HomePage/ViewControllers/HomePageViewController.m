//
//  HomePageViewController.m
//  BaseProject
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HomePageViewController.h"
#import "LLSegmentedControl.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "MJRefresh.h"
#import "FactoryViews.h"
#import "CDZPicker.h"
#import "XMLReader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BannerModel.h"
#import "CarTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "SureConditionModel.h"
#import "SureMultipleSelectedWindow.h"
#pragma mark --  tommy
#import "BannerCell.h"
#import "HomeCarViewModel.h"
#import "HomeCarModel.h"
#import "HomeGoodsViewModel.h"
#import "HomeGoodsModel.h"
#import "CarsDetialViewController.h"
#import "GoodsDetialViewController.h"
#import "LoginViewController.h"
#import "CCWebViewViewController.h"
#import "HomeCarTableViewCell.h"
#import "HomeGoodsTableViewCell.h"
#import "TimeManage.h"
#import "MessageViewController.h"
#import "GuideView.h"

static NSString *KCarSection1CellID = @"KCarSection1CellID";//车源section1 CellID
static NSString *KCarSection2CellID = @"KCarSection2CellID";//车源section2 CellID
static NSString *KCarCyclePageCellID = @"KCarCyclePageCellID";//车源轮播图CellID

static NSString *KGoodsSection1CellID = @"KGoodsSection1CellID";//货源section1 CellID
static NSString *KGoodsSection2CellID = @"KGoodsSection2CellID";//货源section2 CellID
//static NSString *KGoodsCyclePageCellID = @"KGoodsCyclePageCellID";//货源轮播图CellID



@interface HomePageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>{
    CGFloat _navbarHeight;
    CGFloat _tabbarHeight;
    CGFloat _statusbarHeight;
    int page;  //   scrollview  显示页面
}

@property (nonatomic, strong)LLSegmentedControl *TopSegmentedControl;// 导航栏顶部选择器 车源，货源
@property (nonatomic, strong) UIScrollView *segmentBoardScrollView;

@property (nonatomic, strong)UITableView *CarTableView;//车源首页list
@property (nonatomic, strong) NSArray *CarListDatas;//车源列表数据源
@property (nonatomic, strong) TYCyclePagerView *CarPagerView;//车源轮播页
@property (nonatomic, strong) TYPageControl *CarPageControl;//车源轮播页面控制器
@property (nonatomic, strong) NSMutableArray *CarCyclePageDatas;//车源轮播图数据源
@property (nonatomic, copy) NSArray *carToolsButtons;

@property (nonatomic, strong)UITableView *GoodsTableView;//货源首页list
@property (nonatomic, strong) NSArray *GoodsListDatas;//货源列表数据源
//@property (nonatomic, strong) TYCyclePagerView *GoodsPagerView;//货源轮播页
//@property (nonatomic, strong) TYPageControl *GoodsPageControl;//货源轮播页面控制器
//@property (nonatomic, strong) NSMutableArray *GoodsCyclePageDatas;//货源轮播图数据源
@property (nonatomic, copy) NSArray *GoodsToolsButtons;
@property (nonatomic, strong)UIWindow *coverWindow;
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)NSArray *citys;//
#pragma mark--  tommy
@property (nonatomic, strong) HomeCarViewModel *carviewModel;
@property (nonatomic, strong) HomeGoodsViewModel *goodsviewModel;
@property (nonatomic, strong) NSMutableArray *tagDate;
@property (nonatomic, strong) NSMutableArray *tagModel;

@end

@implementation Tagmodel

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXXBarHeight];
    [self setNavigation];
    [_segmentBoardScrollView addSubview:self.CarTableView];
    [_segmentBoardScrollView addSubview:self.GoodsTableView];
    [self requestList];
    if (![ConfigModel getBoolObjectforKey:FirstLoad]) {
        GuideView *view = [[GuideView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
        [view pop];
        [ConfigModel saveBoolObject:YES forKey:FirstLoad];
    }
}


- (void)carLoadmore{
    [[self.carviewModel.homeCarCommand execute:@"homeCar"] subscribeNext:^(NSArray * x) {
        self.CarListDatas = x;
        [self.CarTableView reloadData];
        [self.CarTableView.mj_footer endRefreshing];
        if (!self.carviewModel.haveMore) {
            [self.CarTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)carreload {
    self.carviewModel.page = 1;
    [self.CarTableView.mj_footer resetNoMoreData];
    [[self.carviewModel.homeCarCommand execute:@"homeCar"] subscribeNext:^(NSArray * x) {
        self.CarListDatas = x;
        [self.CarTableView reloadData];
        [self.CarTableView.mj_header endRefreshing];
        if (!self.carviewModel.haveMore) {
            [self.CarTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)goodsloadmore {
    [[self.goodsviewModel.homeGoodsCommad execute:@"homegoods"] subscribeNext:^(NSArray * x) {
        self.GoodsListDatas = x;
        [self.GoodsTableView reloadData];
        [self.GoodsTableView.mj_footer endRefreshing];
        if (!self.goodsviewModel.haveMore) {
            [self.GoodsTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)goodsreload {
    self.goodsviewModel.page = 1;
    [self.GoodsTableView.mj_footer resetNoMoreData];
    [[self.goodsviewModel.homeGoodsCommad execute:@"homegoods"] subscribeNext:^(NSArray * x) {
        self.GoodsListDatas = x;
        [self.GoodsTableView reloadData];
        [self.GoodsTableView.mj_header endRefreshing];
        if (!self.goodsviewModel.haveMore) {
            [self.GoodsTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

-(void)requestList{
    [ConfigModel showHud:self];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [[self.carviewModel.homeCarCommand execute:@"homeCar"] subscribeNext:^(NSArray * x) {
            self.CarListDatas = x;
            [self.CarTableView reloadData];
             dispatch_group_leave(group);
        }];
        
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [[self.goodsviewModel.homeGoodsCommad execute:@"homegoods"] subscribeNext:^(NSArray * x) {
            self.GoodsListDatas = x;
            [self.GoodsTableView reloadData];
            dispatch_group_leave(group);
        }];
    });
    
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        [HttpRequest postPath:@"_userinfo_001" params:nil resultBlock:^(id responseObject, NSError *error) {
//            NSDictionary *datadic = responseObject;
//            if ([datadic[@"error"] intValue] == 0) {
//                NSDictionary *dic = datadic[@"info"];
//                if ([dic[@"approve"] intValue] == 2) {
//                    //  货主认证
//                    [ConfigModel saveBoolObject:YES forKey:Shipper_Certification];
//                }else {
//                     [ConfigModel saveBoolObject:NO forKey:Shipper_Certification];
//                }
//                if ([dic[@"carAuth"] intValue] == 1) {
//                    //  车主认证
//                    [ConfigModel saveBoolObject:YES forKey:Car_Certification];
//                }else {
//                    [ConfigModel saveBoolObject:NO forKey:Car_Certification];
//                }
//
//            }else {
//                NSString *str = datadic[@"info"];
//                [ConfigModel mbProgressHUD:str andView:nil];
//            }
//        }];
//        dispatch_group_leave(group);
//    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSMutableArray *datas = [NSMutableArray array];
        
        [HttpRequest postPath:@"_banner_001" params:nil resultBlock:^(id responseObject, NSError *error) {
            NSDictionary *dic = responseObject;
            NSLog(@"<><><>%@", responseObject);
            int errorint = [dic[@"error"] intValue];
            if (errorint == 0 ) {
                NSArray *bannerDatas = dic[@"info"];
                for (int i = 0; i < bannerDatas.count; i++) {
                    NSDictionary *tmpData =bannerDatas[i];
                    BannerModel *tmpModel = [[BannerModel alloc]init];
                    [tmpModel setValuesForKeysWithDictionary:tmpData];
                    [datas addObject:tmpModel];
                }
                _CarCyclePageDatas = [datas copy];
                [_GoodsTableView reloadData];
                [_CarTableView reloadData];
                dispatch_group_leave(group);
            }else {
                NSString *errorStr = dic[@"info"];
                NSLog(@"%@", errorStr);
                [ConfigModel mbProgressHUD:errorStr andView:nil];
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        
        [HttpRequest postPath:@"_classify_001" params:nil resultBlock:^(id responseObject, NSError *error) {
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"error"] intValue] == 0) {
                NSArray *arr = datadic[@"info"];
                self.tagDate = [NSMutableArray new];
                self.tagDate = [Tagmodel mj_objectArrayWithKeyValuesArray:arr];
                
                dispatch_group_leave(group);
            }else {
                NSString *str = datadic[@"info"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ConfigModel hideHud:self];
        if (!self.carviewModel.haveMore) {
            [self.CarTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (!self.goodsviewModel.haveMore) {
            [self.GoodsTableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}

- (void)setNavigation {
    //  rightBtn
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"xin"] action:@selector(rightBarClick)];
    //  titleView
    NSArray *dataArray = @[@"货源大厅", @"车源大厅"];
    CGFloat const kScrollViewHeight = kScreenH;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScrollViewHeight)];
    scrollView.contentSize = CGSizeMake(kScreenWidth * dataArray.count, kScrollViewHeight);
    scrollView.delegate = self;
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    _segmentBoardScrollView = scrollView;
    for (int i = 0; i < dataArray.count; i ++) {
        CGFloat left = i * kScreenWidth;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(left, 0, kScreenWidth, kScrollViewHeight)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:backgroundView];
    }
}

- (void)rightBarClick {
    
    UnloginReturn
    MessageViewController *com = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:com animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.TopSegmentedControl removeFromSuperview];
    self.TopSegmentedControl = nil;
     [self.navigationItem setTitleView:self.TopSegmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma Mark Delegate
#pragma - segmentScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.segmentBoardScrollView) {
        NSInteger const kPageIndex = scrollView.contentOffset.x / kScreenWidth;
        page =(int)kPageIndex;
        [self.TopSegmentedControl segmentedControlSetSelectedIndex:kPageIndex];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        if (tableView == _CarTableView) {
            return self.CarListDatas.count;
        }
        if (tableView == _GoodsTableView) {
            return self.GoodsListDatas.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:Banner_CELL];
        if (nil == cell) {
            cell = [[BannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Banner_CELL withHeight:180];
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.CarCyclePageDatas.count; i++) {
            BannerModel *model = _CarCyclePageDatas[i];
            [arr addObject:model.img];
        }
        NSMutableArray * imageUrlArr = [[NSMutableArray alloc] initWithArray:arr];
        [cell setContent:imageUrlArr];
        cell.clickViewBlock = ^(NSInteger index) {
            CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
             BannerModel *model = _CarCyclePageDatas[index];
            vc.UrlStr = model.content;
            vc.titlestr = @"详情";
            [self.navigationController pushViewController:vc animated:YES];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else {
        
        if (tableView == _CarTableView) {// 车源
            NSString *cellId = [NSString stringWithFormat:@"k%ld", (long)indexPath.row];
           HomeCarTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[HomeCarTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, 100, kScreenW, 2)];
                line.backgroundColor = RGBColor(239, 240, 241);
                [cell.contentView addSubview:line];
            }
            cell.model = self.CarListDatas[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
        if (tableView == _GoodsTableView) {//货源
            NSString *cellId = [NSString stringWithFormat:@"k%ld", (long)indexPath.row];
            HomeGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[HomeGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, 125, kScreenW, 2)];
                line.backgroundColor = RGBColor(239, 240, 241);
                [cell.contentView addSubview:line];
            }
            cell.model = self.GoodsListDatas[indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        return nil;
    }
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section ? (tableView == self.CarTableView ? 102 : 127) : 180;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section ? 44 : 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    if (section == 1) {
        if (tableView == self.CarTableView) {
                NSArray *CarToolsItemsName = @[@"起点",@"终点",@"装货时间"];
                [self creatToolsWithToolNames:CarToolsItemsName andContainer:0 andPositionX:0 subView:headerView];
        }else {
            NSArray *GoodsToolsItemsName = @[@"起点",@"终点",@"装货时间"];
            [self creatToolsWithToolNames:GoodsToolsItemsName andContainer:1 andPositionX:kScreenW subView:headerView];
        }
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else {
        if (tableView == self.CarTableView) {
            HomeCarModel *model = self.CarListDatas[indexPath.row];
            CarsDetialViewController *vc = [[CarsDetialViewController alloc] init];
            vc.idStr = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (tableView == self.GoodsTableView) {
            HomeGoodsModel *model = self.GoodsListDatas[indexPath.row];
            GoodsDetialViewController *vc = [[GoodsDetialViewController alloc] init];
            vc.idStr = model.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


#pragma Mark - Response
- (void)ToolItemButtonClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;


    if (sender == _carToolsButtons[0] || sender == _carToolsButtons[1] || sender == _GoodsToolsButtons[0] || sender == _GoodsToolsButtons[1]) {// 起点 终点
        NSMutableArray *allProvinceComponent = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.citys.count; i++) {
            NSDictionary *tmpProvince = self.citys[i];
            NSArray *tmpCitys = tmpProvince[@"citys"];
            NSString *parovinceName = tmpProvince[@"provinceName"];
            CDZPickerComponentObject *provinceComponentObject = [[CDZPickerComponentObject alloc]initWithText:parovinceName];
            for (int j = 0; j < tmpCitys.count; j++) {
                NSDictionary *tmpCity = tmpCitys[j];
                NSString *cityName = tmpCity[@"citysName"];
                CDZPickerComponentObject *cityComponentObject = [[CDZPickerComponentObject alloc]initWithText:cityName];
                [provinceComponentObject.subArray addObject:cityComponentObject];
            }
            [allProvinceComponent addObject:provinceComponentObject];
        }
        self.alertView.hidden = NO;
        self.coverWindow.hidden = NO;
        [CDZPicker showLinkagePickerInView:self.alertView withBuilder:nil components:allProvinceComponent confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
            sender.selected = !sender.isSelected;
            self.coverWindow.hidden = YES;
            self.alertView.hidden = YES;
            NSString *city = strings[1];
            NSString *provin = strings[0];
            [sender setTitle:city forState:UIControlStateNormal];
            NSString *str = [NSString stringWithFormat:@"%@%@", provin, city];
            if (sender == _carToolsButtons[0]) {
                self.carviewModel.origin = str;
            }
            if (sender == _carToolsButtons[1]) {
                self.carviewModel.destination = str;
            }
            if (sender == _GoodsToolsButtons[0]) {
                self.goodsviewModel.loading = str;
            }
            if (sender == _GoodsToolsButtons[1]) {
                self.goodsviewModel.destination = str;
            }
            self.carviewModel.page = 1; self.goodsviewModel.page = 1;
            [self requestList];
            
            
        }cancel:^{
            //your code
            sender.selected = !sender.isSelected;
            self.coverWindow.hidden = YES;
            self.alertView.hidden = YES;
        }];
    }
    if (sender == _carToolsButtons[2] || sender == _GoodsToolsButtons[2]) {//天数
        CDZPickerBuilder *builder = [CDZPickerBuilder new];
        builder.showMask = YES;
            self.alertView.hidden = NO;
            self.coverWindow.hidden = NO;
        [CDZPicker showSinglePickerInView:_alertView withBuilder:builder strings:@[@"不限",@"一天以内",@"两天以内",@"三天以内"] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
            NSLog(@"strings:%@ indexs:%@",strings,indexs);
            sender.selected = !sender.isSelected;
            self.coverWindow.hidden = YES;
            self.alertView.hidden = YES;
            NSString *data = strings[0];
            [sender setTitle:data forState:UIControlStateNormal];
            
            if (sender == _carToolsButtons[2]) {
                self.carviewModel.data = data;
            }
            if (sender == _GoodsToolsButtons[2]) {
                self.goodsviewModel.data = data;
            }
            
            self.carviewModel.page = 1; self.goodsviewModel.page = 1;
            [self requestList];
            
        }cancel:^{
            sender.selected = !sender.isSelected;
            self.coverWindow.hidden = YES;
            self.alertView.hidden = YES;
        }];
    }
//    if (sender == _GoodsToolsButtons[2]) {
//        
//        NSMutableArray *tagstr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < self.tagDate.count; i++) {
//            Tagmodel *model = self.tagDate[i];
//            [tagstr addObject:model.type];
//        }
//        
//        [SureMultipleSelectedWindow showWindowWithTitle:@"" selectedConditions:tagstr defaultSelectedConditions:self.tagModel selectedBlock:^(NSArray *selectedArr) {
//             sender.selected = !sender.isSelected;
//            if (selectedArr) {
//                [self.tagModel removeAllObjects];
//                if (selectedArr.count > 0) {
//                    if (![selectedArr[0] isKindOfClass:[NSString class]]) {
//                        for (SureConditionModel *model in selectedArr) {
//                            [self.tagModel addObject:model.title];
//                        }
//                    }
//                }
//            }
//            NSMutableArray *idarr = [[NSMutableArray alloc] init];
//            for (int i = 0; i < self.tagDate.count; i++) {
//                Tagmodel *model = self.tagDate[i];
//                for (int j = 0; j <self.tagModel.count; j++) {
//                    NSString *str = self.tagModel[j];
//                    if ([str isEqualToString:model.type]) {
//                        [idarr addObject:model.id];
//                    }
//                }
//            }
//            NSString *cateStr;
//            for (int i = 0; i < idarr.count; i++) {
//                NSString *str = idarr[i];
//                if (i == 0) {
//                    cateStr = str;
//                }else {
//                    NSString *morestr = [NSString stringWithFormat:@",%@", str];
//                    cateStr = [cateStr stringByAppendingString:morestr];
//                }
//            }
//            if (!cateStr) {
//                cateStr = nil;
//            }
//            self.goodsviewModel.type = cateStr;
//            self.carviewModel.page = 1; self.goodsviewModel.page = 1;
//            [self requestList];
//            
//        }];
//    }
}

#pragma Mark - Prvite Method
- (void)setXXBarHeight{
    page = 0;
    _statusbarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _navbarHeight = self.navigationController.navigationBar.frame.size.height;
    _tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    NSLog(@"Heiht = %f,%f,%f",_statusbarHeight,_navbarHeight,_tabbarHeight);
    [ConfigModel saveString:[NSString stringWithFormat:@"%f", _statusbarHeight] forKey:@"_statusbarHeight"];
    [ConfigModel saveString:[NSString stringWithFormat:@"%f", _navbarHeight] forKey:@"_navbarHeight"];
    [ConfigModel saveString:[NSString stringWithFormat:@"%f", _tabbarHeight] forKey:@"_tabbarHeight"];
    
}

- (void)creatToolsWithToolNames:(NSArray *)names andContainer:(NSInteger)buttonsNumber andPositionX:(CGFloat)x subView:(UIView *)view{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.userInteractionEnabled = YES;
    
    NSMutableArray *tmpItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < names.count; i++) {
        NSString *itemName = names[i];
        if (buttonsNumber == 0 && _carToolsButtons) {
            UIButton *btn = _carToolsButtons[i];
            itemName = btn.titleLabel.text;
        }
        
        if (buttonsNumber == 1 && _GoodsToolsButtons) {
            UIButton *btn = _GoodsToolsButtons[i];
            itemName = btn.titleLabel.text;
        }
        
        CGFloat itemWidth = kScreenW / names.count;
        UIButton *itemButton = [FactoryViews CreatToolsButtonItemWithTitle:itemName andImage:[UIImage  imageNamed:@"jiantou"] andSelectedImage:[UIImage imageNamed:@"jiantouq"] addTarget:self action:@selector(ToolItemButtonClick:)];
        itemButton.frame = CGRectMake(itemWidth * i, 0, itemWidth, 44);
        [headView addSubview:itemButton];
        [tmpItems addObject:itemButton];
        if (i != 0 && i != 3) {
            UIView *vLine = [[UIView alloc] init];
            vLine.frame = CGRectMake(itemWidth * i,7,0.5,30);
            vLine.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
            [headView addSubview:vLine];
        }
    }
    if (buttonsNumber == 0) {
        _carToolsButtons = tmpItems;
    }else{
        _GoodsToolsButtons = tmpItems;
    }
    // top bottom line
    UIView *topLine = [[UIView alloc] init];
    topLine.frame = CGRectMake(0,0,kScreenW,1);
    topLine.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [headView addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.frame = CGRectMake(0,43,kScreenW,1);
    bottomLine.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [headView addSubview:bottomLine];
    [view addSubview:headView];
}

#pragma Mark - Setter Getter
- (LLSegmentedControl *)TopSegmentedControl{// 导航栏顶部 segment
    if (!_TopSegmentedControl) {
        NSArray *dataArray = @[@"货源大厅", @"车源大厅"];
        _TopSegmentedControl = [[LLSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 220, 44) titleArray:dataArray];
        _TopSegmentedControl.backgroundColor = [UIColor clearColor];
        _TopSegmentedControl.segmentedControlLineStyle = LLSegmentedControlStyleUnderline;
        _TopSegmentedControl.segmentedControlTitleSpacingStyle = LLSegmentedControlTitleSpacingStyleWidthAutoFit;
        _TopSegmentedControl.lineWidthEqualToTextWidth = YES;
        _TopSegmentedControl.textColor = [UIColor whiteColor];
        _TopSegmentedControl.selectedTextColor = [UIColor whiteColor];
        _TopSegmentedControl.font = [UIFont systemFontOfSize:18];
        _TopSegmentedControl.selectedFont = [UIFont boldSystemFontOfSize:18];
        _TopSegmentedControl.lineColor = [UIColor whiteColor];
        _TopSegmentedControl.lineHeight = 2.f;
        // segmentedControlTitleSpacingStyle 设置为 LLSegmentedControlTitleSpacingStyleSpacingFixed
        // 则不需要设置 titleWidth 属性
        _TopSegmentedControl.titleSpacing = 40;
        _TopSegmentedControl.defaultSelectedIndex = page;
        
        [_TopSegmentedControl segmentedControlSelectedWithBlock:^(LLSegmentedControl *segmentedControl, NSInteger selectedIndex) {
            page = (int)selectedIndex;
            [_segmentBoardScrollView setContentOffset:CGPointMake(selectedIndex * kScreenWidth, 0) animated:YES];
        }];
    }
    return _TopSegmentedControl;
}

//车源list视图
- (UITableView *)CarTableView{
    if (!_CarTableView) {
        _CarTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW,0, kScreenW, kScreenH -  _statusbarHeight - _tabbarHeight - _navbarHeight) style:UITableViewStylePlain];
        _CarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _CarTableView.delegate = self;
        _CarTableView.dataSource = self;
        _GoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 下拉刷新
        _CarTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self carreload];
        }];
        //  上拉加载
        _CarTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self carLoadmore];
        }];
        _CarTableView.backgroundColor = [UIColor whiteColor];
    }
    return _CarTableView;
}

//车源list数据源
- (NSArray *)CarListDatas{
    if (!_CarListDatas) {
        _CarListDatas = [[NSArray alloc]init];
    }
    return _CarListDatas;
}
//货源list视图
- (UITableView *)GoodsTableView{
    if (!_GoodsTableView) {
        _GoodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -  _statusbarHeight - _tabbarHeight - _navbarHeight ) style:UITableViewStylePlain];
        // 下拉刷新
        _GoodsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _GoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _GoodsTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self goodsreload];
        }];
        //  上拉加载
        _GoodsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self goodsloadmore];
        }];
        _GoodsTableView.delegate = self;
        _GoodsTableView.dataSource = self;
    }
    return _GoodsTableView;
}

//货源list数据源
- (NSArray *)GoodsListDatas{
    if (!_GoodsListDatas) {
        _GoodsListDatas = [[NSArray alloc]init];
    }
    return _GoodsListDatas;
}

//弹框
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenH)];
        _coverWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenH)];
        _coverWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _alertView.clipsToBounds = YES;
        _alertView.layer.cornerRadius = 4;
        [_coverWindow addSubview:_alertView];
        _coverWindow.windowLevel = UIWindowLevelNormal;
        _coverWindow.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_coverWindow];
    }
    return _alertView;
}

- (NSArray *)citys{
    if (!_citys) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"citydatas" ofType:@"xml"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *dic1 = [XMLReader dictionaryForXMLData:data error:&error];
        NSData *JSONData = [dic1[@"resources"][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"LY - %@",responseJSON[@"provinces"]);
        _citys = [responseJSON[@"provinces"] copy];
    }
    return _citys;
}

- (HomeCarViewModel *)carviewModel {
    if (!_carviewModel) {
        _carviewModel = [[HomeCarViewModel alloc] init];
    }
    return _carviewModel;
}

- (HomeGoodsViewModel *)goodsviewModel {
    if (!_goodsviewModel) {
        _goodsviewModel = [[HomeGoodsViewModel alloc] init];
    }
    return _goodsviewModel;
}

- (NSMutableArray *)tagModel {
    if (!_tagModel) {
        _tagModel = [[NSMutableArray alloc] init];
    }
    return _tagModel;
}



@end
