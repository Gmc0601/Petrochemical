//
//  GuideView.h
//  BaseProject
//
//  Created by cc on 2018/5/5.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) int showtime;

- (void)pop;

@end
