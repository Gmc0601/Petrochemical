//
//  LogisticsDetailsViewController.m
//  BaseProject
//
//  Created by Yitian on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "LogisticsDetailsViewController.h"
#import "Masonry.h"
@interface LogisticsDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *carNumberView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
- (IBAction)clickCall:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *listView;

@property(nonatomic,strong)NSArray *listArray;
@end

@implementation LogisticsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomerTitle:@"运输物流信息"];
    
    self.carNumberView.layer.cornerRadius = 3;
    self.carNumberView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    self.carNumberLabel.layer.cornerRadius = 3;
    self.carNumberLabel.layer.masksToBounds = YES;
     [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DefaultImage];
    self.listArray = @[@{@"remarks":@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",@"date":@"2018-08-08 18:58:58",@"image":@[@{},@{}]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[@{},@{},@{},@{},@{},@{}]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[@{},@{},@{},@{},@{},@{}]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[@{},@{},@{},@{},@{},@{}]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[@{},@{},@{},@{},@{},@{}]},@{@"remarks":@"adfjaldfjalfjheheh呵呵呵呵呵呵呵呵",@"date":@"2018-08-08 18:58:59",@"image":@[@{},@{},@{},@{},@{},@{}]}];
    [self loadListView];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadListView{
    
    UIView *lastView;
    for (int i = 0; i<self.listArray.count; i++) {
        NSDictionary *dataDic = self.listArray[i];
        UIView *itemView = [[UIView alloc] init];
        [self.listView addSubview:itemView];
        itemView.clipsToBounds = YES;
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }
            else{
                make.top.mas_equalTo(0);
            }
            make.left.mas_equalTo(35);
            make.right.mas_equalTo(-35);
        }];
        
        UIImageView *bluePointImageView = [[UIImageView alloc] init];
        bluePointImageView.image = [UIImage imageNamed:@"tuoyuan"];
        [itemView addSubview:bluePointImageView];
        
        [bluePointImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = RGBColor(36, 36, 36);
        textLabel.numberOfLines = 0;
        [itemView addSubview:textLabel];
        textLabel.text = dataDic[@"remarks"];
        [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.equalTo(bluePointImageView.mas_right).offset(5);
            make.right.mas_equalTo(-12);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        

        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = RGBColor(36, 36, 36);
        [itemView addSubview:dateLabel];
        dateLabel.text = dataDic[@"date"];
        [dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textLabel.mas_bottom).offset(5);
            make.left.equalTo(textLabel.mas_left);
            make.right.equalTo(textLabel.mas_right);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        NSArray *imagesArray = dataDic[@"image"];
        if (imagesArray.count) {
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            [itemView addSubview:scrollView];
            [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dateLabel.mas_bottom).offset(5);
                make.left.equalTo(textLabel.mas_left);
                make.right.equalTo(textLabel.mas_right);
                make.height.mas_equalTo(50);
                make.bottom.mas_equalTo(-10);
            }];

            for (int i = 0; i<imagesArray.count; i++) {
                NSDictionary *imageDic = imagesArray[i];
                
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageDic[@"url"]?:@""] placeholderImage:DefaultImage];
                [scrollView addSubview:imageView];
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                    make.left.mas_equalTo((50+10)*i);
                    if (i==imagesArray.count-1) {
                        make.right.mas_equalTo(0);
                    }
                }];
                
            }
            
        }
        else{
            [dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-10);
            }];
        }
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGBColor(227, 227, 227);
        [itemView addSubview:lineLabel];
        [lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
          
            make.left.equalTo(textLabel.mas_left);
            make.right.equalTo(textLabel.mas_right);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(itemView.mas_bottom);
        }];
        
        lastView = itemView;
        
    }
    
    if (lastView) {
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGBColor(158, 213, 255);
        [self.listView insertSubview:lineLabel atIndex:0];
        [lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.equalTo(@42);
            make.width.mas_equalTo(1);
            make.bottom.equalTo(lastView.mas_top).offset(10);
        }];
        
        [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom);
        }];
    }
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

- (IBAction)clickCall:(id)sender {
}
@end
