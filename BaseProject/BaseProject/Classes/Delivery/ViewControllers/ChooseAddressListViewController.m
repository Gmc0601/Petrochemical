


//
//  ChooseAddressListViewController.m
//  BaseProject
//
//  Created by DCQ on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChooseAddressListViewController.h"
#import "ChooseAddressSearchView.h"
#import "CityPickerVeiw.h"
@interface ChooseAddressListViewController ()

@end

@implementation ChooseAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomerTitle:@"选择地点"];
    [self setupHeaderView];
}
- (void)setupHeaderView{
    
    ChooseAddressSearchView * searchView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ChooseAddressSearchView class]) owner:nil options:nil].firstObject;
    searchView.tag = 98989893;
   
    [self.view addSubview:searchView];
    searchView.frame = CGRectMake(0, self.CC_table.frame.origin.y-50, self.view.frame.size.width, 50);
    searchView.inputText = ^(NSString *inputText) {
        [self searchInput:inputText];
    };
    searchView.areaBlock = ^{
        [self showCityPicker];
    };
}
-(CGRect)getTableFrame{
    return CGRectMake(0, 64 + 50, kScreenW, kScreenH - 64 - 50);
}

- (void)searchInput:(NSString *)inputText{
    
    
}


- (void)showCityPicker  {
    CityPickerVeiw * cityView = [[CityPickerVeiw alloc] initWithFrame:CGRectZero withType:PickerViewType_city];
    cityView.col = 2;
    [cityView show];
    cityView.showSelectedCityNameStr =@"" ;
    [cityView setCityBlock:^(NSString * value) {
        NSLog(@"%@===",value);
          NSArray * array = [value componentsSeparatedByString:@"-"];
        if ([array count] == 2) {
            NSString * areaStr = array[1];
            ChooseAddressSearchView * searchView  = [self.view viewWithTag:98989893];
            [searchView setupArea:areaStr];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
