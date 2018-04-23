//
//  cityPickerVeiw.m
//  丢必得
//
//  Created by ZSMAC on 17/9/6.
//  Copyright © 2017年 zhangwenshuai. All rights reserved.
//

#import "CityPickerVeiw.h"
#import "CityNameModel.h"
#import "ZSAnalysisClass.h"  // 数据转模型类
#import "UIView+GoodView.h"

#define SCREEN [UIScreen mainScreen].bounds.size

@interface CityPickerVeiw()
@property(nonatomic, assign)PickerViewType  pickerType;
@end
@implementation CityPickerVeiw
{
    CityNameModel * sourceModel;
    NSArray * section1;
    NSArray * section2;
    NSArray * section3;
    NSString * provinceStr;
    NSString * cityStr;
    NSString * districtStr;
    NSString * resultsStr;
    UIPickerView * cityPickerView;

}
- (instancetype)initWithFrame:(CGRect)frame withType:(PickerViewType )pickerType {
    self=[super initWithFrame:frame];
    if (self) {
        self.pickerType = pickerType;
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        if (self.pickerType == PickerViewType_city) {
            [self dataCityConfiguer];
           
        }else if (self.pickerType == PickerViewType_carTimer || self.pickerType == PickerViewType_goodsTimer){
            [self dataTimerConfiguer];
        }
        [self uiConfiguer];
    }
    return self;
}
- (void)dataCityConfiguer {
    
    //获取总资源
    sourceModel=  [self getModel];
    //全部的省数组
    section1=sourceModel.province;
    //取出市数组 （一个省的所有城市）
    province * shiModel = sourceModel.province.firstObject;
    section2 = shiModel.city;
    
    city * xianModel = shiModel.city.firstObject;
    section3 = xianModel.district;
    
    province *sheng=section1.firstObject;
    provinceStr=sheng.name;
    
    city *shi=section2.firstObject;
    cityStr=shi.name;
    
    district *xian=section3.firstObject;
    districtStr=xian.name;
    
    resultsStr=[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,districtStr];

}

- (void)dataTimerConfiguer{

    section1 =[self getMonthDay];
    NSString * tempType = @"";
    if (  self.pickerType == PickerViewType_goodsTimer) {
        tempType = @"随时装货";
    }else if (self.pickerType == PickerViewType_carTimer){
        tempType = @"随时装车";
    }
    section2 = [self getTimeInterval:tempType];
//    section2 = [self getDaysAtMonth:1 atYears:[self getCurrentYear]];
//    section3 =[self  getHours];
    
    
}
- (NSArray *)getTimeInterval:(NSString *)monthDay{
      NSMutableArray * array = [NSMutableArray array];
    NSString * tempType = @"";
    if (  self.pickerType == PickerViewType_goodsTimer) {
        tempType = @"随时装货";
    }else if (self.pickerType == PickerViewType_carTimer){
        tempType = @"随时装车";
    }
    if ([monthDay isEqualToString:tempType]) {
        [array addObject:@"全天"];
    }else{
         [array addObject:@"全天"];
        for (NSInteger interval =  0; interval <= 20; interval++) {
            
            if (interval%4 == 0) {
                NSString * intervalStr = @"";
                NSString * center = @"-";
                if (interval<10) {
                    NSString * startTimer = @"";
                     NSString * endTimer = @"";
                    
                    if (interval +4 <10) {
                        endTimer = [NSString stringWithFormat:@"0%ld:00",interval+4];
                    }else{
                        endTimer = [NSString stringWithFormat:@"%ld:00",interval+4];
                    }
                      startTimer = [NSString stringWithFormat:@"0%ld:00",interval];
                    intervalStr  = [startTimer stringByAppendingString:center];
                    intervalStr =  [intervalStr  stringByAppendingString:endTimer];
                }else{
                    NSString * startTimer = @"";
                    NSString * endTimer = @"";
                    endTimer = [NSString stringWithFormat:@"%ld:00",interval+4];
                    startTimer = [NSString stringWithFormat:@"%ld:00",interval];
                    intervalStr  = [startTimer stringByAppendingString:center];
                    intervalStr =  [intervalStr  stringByAppendingString:endTimer];
                }
                [array addObject:intervalStr];
            }
        }
    }
    return array;
}
- (NSArray *)getMonthDay{
    NSMutableArray * array = [NSMutableArray array];
    NSInteger currentMoth = [self  getCurrentMonth];
    NSInteger currentDay  = [self getCurrentDay];
    for (NSInteger i = currentMoth;  i< ((currentDay >1?1:0) +12 + currentMoth) ; i++) {
        NSInteger tempMoth = i;
        NSInteger tempYears = [self getCurrentYear];
        if (i > 12) {
            tempMoth= i-12;
            tempYears = tempYears + 1;
        }
       NSArray * days = [self getDaysAtMonth:tempMoth atYears:tempYears];
        if (currentMoth != i) {
            currentDay = 1;
        }
        for (NSInteger day = currentDay ;day <= [days count] ; day++) {
            NSInteger tempDay = day;
            NSString *monthDay = @"";
            if (i == currentMoth && day == currentDay) {
                NSString * tempType = @"";
                if (  self.pickerType == PickerViewType_goodsTimer) {
                    tempType = @"随时装货";
                }else if (self.pickerType == PickerViewType_carTimer){
                    tempType = @"随时装车";
                }
                monthDay = [NSString stringWithFormat:tempType];
            }else{
                monthDay = [NSString stringWithFormat:@"%ld月%ld日",(long)tempMoth,(long)tempDay]; 
            }
            [array addObject:monthDay];
        }
    }
    
 
   
    return  array;
}
- (NSArray *)getMonth{
    NSMutableArray * array = [NSMutableArray array];
    for (NSInteger i = 1; i<=12; i++) {
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return array;
}
- (NSInteger)getCurrentYear{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
 
    return comp.year;
}
- (NSInteger)getCurrentDay{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    
    return comp.day;
}

- (NSInteger)getCurrentMonth{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
 
    return comp.month;
}
- (NSArray *)getDaysAtMonth:(NSInteger )month atYears:(NSInteger)years{
    NSMutableArray * array = [NSMutableArray array];
    NSInteger days = [self howManyDaysInThisYear:years  withMonth:month ];
    for (NSInteger i = 1; i<= days; i++) {
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return array;
 
}
- (NSArray *)getHours{
    NSMutableArray * array = [NSMutableArray array];
    for (NSInteger i = 1; i<=24; i++) {
        [array addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return array;
}

- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}
#pragma mark 显示已选择的
- (void)setShowSelectedCityNameStr:(NSString *)showSelectedCityNameStr {
    _showSelectedCityNameStr=showSelectedCityNameStr;
    
    
    NSUInteger index1=0;
    NSUInteger index2=0;
    NSUInteger index3=0;
    
    if (self.pickerType == PickerViewType_city) {
        NSArray * nameArray = [_showSelectedCityNameStr componentsSeparatedByString:@"-"];
        
        if (nameArray.count==3) {
            NSString * name1 = nameArray.firstObject;
            NSUInteger index=0;
            for (province *model in section1) {
                if ([model.name isEqualToString:name1]) {
                    index= [section1 indexOfObject:model];
                    break;
                }
            }
            index1=index;
            NSString * name2 = nameArray[1];
            //第二个区
            province * section1Model =section1[index];
            section2 =section1Model.city;
            for (city * xianModel in section2) {
                if ([xianModel.name isEqualToString:name2]) {
                    index= [section2 indexOfObject:xianModel];
                    break;
                }
            }
            index2=index;
            NSString * name3 = nameArray.lastObject;
            //第三个区
            city * cityModel =section2[index];
            section3 =cityModel.district;
            for (district * districtModel in section3) {
                if ([districtModel.name isEqualToString:name3]) {
                    index= [section3 indexOfObject:districtModel];
                    break;
                }
            }
            index3=index;
            [cityPickerView reloadAllComponents];
        }
        
        [cityPickerView selectRow:index1 inComponent:0 animated:NO];
        if (self.col == 2) {
            [cityPickerView selectRow:index2 inComponent:1 animated:NO];
        }
        if (self.col==3) {
            [cityPickerView selectRow:index3 inComponent:2 animated:NO];
        }
        province *sheng=[section1 objectAtIndex:index1];
        provinceStr=sheng.name;
        city *shi=[section2 objectAtIndex:index2];
        cityStr=shi.name;
        district *xian=[section3 objectAtIndex:index3];
        districtStr=xian.name;
        resultsStr=[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,districtStr];
    }else if (self.pickerType == PickerViewType_carTimer || self.pickerType == PickerViewType_goodsTimer){
        if (showSelectedCityNameStr) {
            NSArray * timerArray = [showSelectedCityNameStr componentsSeparatedByString:@" "];
            if ( [timerArray count] >1) {
                if ([[self getMonthDay] containsObject: timerArray[0]]) {
                    index1 = [[self getMonthDay] indexOfObject:timerArray[0]];
                }
                NSString * temp = [self getMonthDay][index1];
                section2 =  [self getTimeInterval:temp];
                if([section2 containsObject: timerArray[1]]){
                    index2 = [section2 indexOfObject:timerArray[1]];
                }
            }
        }
      [cityPickerView reloadComponent:1];
        [cityPickerView selectRow:index1 inComponent:0 animated:NO];
        if (self.col == 2) {
            [cityPickerView selectRow:index2 inComponent:1 animated:NO];
        }
        provinceStr =[NSString stringWithFormat:@"%@",[section1 objectAtIndex:index1]];
        cityStr = [section2 objectAtIndex:index2];
        resultsStr =  [NSString stringWithFormat:@"%@ %@",provinceStr,cityStr];
       
    }
    

}
- (CityNameModel *)getModel {
    NSString *jsonPath=[[NSBundle mainBundle]pathForResource:@"province_data.json" ofType:nil];
    NSData *jsonData=[[NSData alloc]initWithContentsOfFile:jsonPath];
    ZSAnalysisClass * AnalysisClass = [[ZSAnalysisClass alloc] parsingWithData:jsonData modelClassName:@"CityNameModel"];
    CityNameModel *  cityModel=(CityNameModel *)AnalysisClass.paresData;
    return  cityModel;
}

-(void)uiConfiguer{
    _bageView= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, 260)];
//    _bageView.backgroundColor=[UIColor colorWithRed: arc4random_uniform(256)/255.0f green: arc4random_uniform(256)/255.0f blue: arc4random_uniform(256)/255.0f alpha:1];
    _bageView.backgroundColor = UIColorFromHex(0XF2F2F2);
    _bageView.userInteractionEnabled=YES;
    [self addSubview:_bageView];
    
    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 5, 40, 30)];
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromHex(0x4893F6) forState:UIControlStateNormal];
    [_bageView addSubview:cancelBtn];
    
    UIButton * completeBtn=[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.width-50, 5, 40, 30)];
    [completeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:UIColorFromHex(0x4893F6) forState:UIControlStateNormal];
    [_bageView addSubview:completeBtn];
    
    cityPickerView=[[UIPickerView alloc]init];
    cityPickerView.frame=CGRectMake(0, completeBtn.bottom+5, SCREEN.width, _bageView.height-completeBtn.bottom-5);
    cityPickerView.delegate=self;
    cityPickerView.dataSource=self;
    cityPickerView.backgroundColor=[UIColor whiteColor];
    [_bageView addSubview:cityPickerView];
    
    
}

//  设置对应的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.width-30)/3,40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}
-(void)btnClicked:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismis];
    } else {
        if (self.CityBlock) {
            self.CityBlock(resultsStr);
             [self dismis];
        }
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger number = 2;
    if (self.col) {
        number = self.col;
    }
    return number;
}
//多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result=0;
    if (component == 0) {
        result= section1.count;
    }
    else if (component== 1){
        result= section2.count;
    }
    else if (component== 2){
        result= section3.count;
    }
    
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    if (self.pickerType == PickerViewType_carTimer || self.pickerType == PickerViewType_goodsTimer) {
        if (component ==0 ) {
           
            title = [NSString stringWithFormat:@"%@",section1[row]];
            
        }
        else if (component== 1){
             title =  [NSString stringWithFormat:@"%@",section2[row]];
        }
        else if (component== 2){
            title = [NSString stringWithFormat:@"%@",section3[row]];
        }
    }else if (self.pickerType == PickerViewType_city){
        if (component ==0 ) {
            province * prModel = section1[row];
            title = prModel.name;
            
        }
        else if (component== 1){
            city * cModel = section2[row];
            title = cModel.name;
            
        }
        else if (component== 2){
            district * disModel = section3[row];
            title = disModel.name;
        }
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerType == PickerViewType_carTimer || self.pickerType == PickerViewType_goodsTimer) {
        //滚动一区的时候
        if (component==0) {
            NSString * month = section1[row] ;
//            section2= [self getDaysAtMonth:month atYears:[self getCurrentYear]];
              section2 = [self getTimeInterval:month];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        
    }else if (self.pickerType == PickerViewType_city){
        //滚动一区的时候
        if (component==0) {
            province *Prmodel =sourceModel.province[row];
            section2=Prmodel.city;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            if (self.col == 3) {
                city * ciModel = section2[0];
                section3=ciModel.district;
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
            }
            //滚动二区的时候
        } else if (component==1) {
            city * ciModel = section2[row];
            section3=ciModel.district;
            if (self.col == 3) {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
            }
            
        }
       
    }
  
     [self setModelComponent:component Row:row];
    
}
- (void)setModelComponent:(NSInteger)component Row:(NSInteger)row {
    
    if (self.pickerType == PickerViewType_carTimer || self.pickerType == PickerViewType_goodsTimer) {
        
        if (component == 0) {
            provinceStr = section1[row];
           
        } else if (component==1) {
            cityStr = section2[row];
          
        } else {
            districtStr =section3[row];
        }
        resultsStr = [NSString stringWithFormat:@"%@ %@",provinceStr,cityStr];
//        resultsStr = [NSString stringWithFormat:@"%ld-%@-%@ %@:00:00",[self getCurrentYear],provinceStr,cityStr,districtStr];
        
    }else if (self.pickerType == PickerViewType_city){
        if (component == 0) {
            province *Prmodel =section1[row];
            city * ciModel = Prmodel.city.firstObject;
            //省
            provinceStr =Prmodel.name;
            //市
            cityStr=ciModel.name;
            //xian
            district *model3 =ciModel.district.firstObject;
            districtStr=model3.name;
        } else if (component==1) {
            
            city * ciModel = section2[row];
            //市
            cityStr=ciModel.name;
            //县
            district *model3 =ciModel.district.firstObject;
            districtStr=model3.name;
            
        } else {
            //县
            district *model3 =section3[row];
            districtStr = model3.name;
        }
        resultsStr = [NSString stringWithFormat:@"%@",provinceStr];
                      
        if (self.col == 2) {
            resultsStr = [resultsStr stringByAppendingFormat:@"-%@",cityStr];
        }else if (self.col == 3) {
             resultsStr = [resultsStr stringByAppendingFormat:@"-%@",cityStr];
             resultsStr = [resultsStr stringByAppendingFormat:@"-%@",districtStr];
        }
        
    }
   
}
- (void)show {
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bageView.top=SCREEN.height-self.bageView.height;
    }];
}
- (void)dismis {
    [UIView animateWithDuration:0.3 animations:^{
        self.bageView.top=SCREEN.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
