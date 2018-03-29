//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *bannerImage;
@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       // [self addLabel];
        [self addImage];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
       // [self addLabel];
        [self addImage];
    }
    return self;
}


- (void)addLabel {
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];
    _label = label;
}

- (void)addImage {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    _bannerImage = imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //_label.frame = self.bounds;
    _bannerImage.frame = self.bounds;
}

- (void)setModel:(BannerModel *)model{
    _model = model;
    NSString *urlStr = model.img;
    if (urlStr) {
        NSURL *url = [NSURL URLWithString:urlStr];
        [_bannerImage sd_setImageWithURL:url placeholderImage:[UIImage new]];
    }
   
}

@end
