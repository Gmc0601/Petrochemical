//
//  GuideView.m
//  BaseProject
//
//  Created by cc on 2018/5/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.showtime = 1;
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *imageStr = [NSString stringWithFormat:@"load%d", self.showtime];
        self.imageView.image = [UIImage imageNamed:imageStr];
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestuer:)];
        [self addGestureRecognizer:tapGuesture];
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)tapgestuer:(UITapGestureRecognizer *)sender {
    if (self.showtime == 5) {
        [self dismiss];
    }
    self.showtime ++;
    NSString *imageStr = [NSString stringWithFormat:@"load%d", self.showtime];
    self.imageView.image = [UIImage imageNamed:imageStr];
}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];

}

@end
