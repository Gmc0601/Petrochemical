//
//  ImageCollectionViewCell.h
//  blueberry
//
//  Created by 汤鹏 on 15-1-22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property(nonatomic,strong) UIImageView *  selectImage;
@property(nonatomic,strong) UIScrollView * scroll;
@property(nonatomic,strong) UIImageView * smallImage;
@property(nonatomic,strong) UIActivityIndicatorView * loading;
-(void) boundImage:(NSString *) path smallPath:(NSString *)smallPath;
@end
