//
//  BannnerCell.m
//  HuoHaoApp
//
//  Created by liqu on 16/8/2.
//  Copyright © 2016年 com.HuoHao.app. All rights reserved.
//

#import "BannerCell.h"
@interface BannerCell()

@property(nonatomic,strong)SDCycleScrollView * cycleScrollView;

@end

@implementation BannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeight:(CGFloat)heigh
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.userInteractionEnabled=YES;
        CGFloat height;
        height = heigh;
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW,height) delegate:self  placeholderImage:[UIImage imageNamed:@"750"]];
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.cycleScrollView.pageControlStyle   = SDCycleScrollViewPageContolStyleAnimated;
        self.cycleScrollView.autoScrollTimeInterval = 4.0;
        [self addSubview: self.cycleScrollView];
    }
    return self;
}

- (void)setContent:(NSMutableArray *)model{
    
        self.cycleScrollView.imageURLStringsGroup = model;

}

- (void)setimage:(NSMutableArray *)array {
    
    self.cycleScrollView.imageURLStringsGroup = array;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.clickViewBlock) {
        self.clickViewBlock(index);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
