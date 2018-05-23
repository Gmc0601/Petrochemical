//
//  TPImageShow.h
//  blueberry
//
//  Created by 汤鹏 on 15-1-22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPImageShow : UIView
@property(nonatomic,assign) NSInteger currentIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
+(instancetype)imageShowWithData:(NSArray * ) imagePathArr  andSmallImageData:(NSArray *) imageSmallArr currentIndex:(NSInteger )index clickImage:(UIImageView * )image;
@end
