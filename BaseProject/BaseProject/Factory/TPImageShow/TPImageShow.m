//
//  TPImageShow.m
//  blueberry
//
//  Created by 汤鹏 on 15-1-22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "TPImageShow.h"
#import "ImageCollectionViewCell.h"
#import "UIView+Extension.h"
 
#define customTag 1023
@interface TPImageShow()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray * _imageData;
    NSArray * _imageSmallData;
}
@end
@implementation TPImageShow
static NSString * const imageCell =@"imagecell";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)imageShowWithData:(NSArray * ) imagePathArr andSmallImageData:(NSArray *) imageSmallArr  currentIndex:(NSInteger )index clickImage:(UIImageView *)image{
    TPImageShow * show = [[TPImageShow alloc]initWithData:imagePathArr andSmallImageData:imageSmallArr currentIndex:index clickImage:(UIImageView *)image];
    return show;
}
-(instancetype)initWithData:(NSArray * ) imagePathArr andSmallImageData:(NSArray *) imageSmallArr  currentIndex:(NSInteger )index clickImage:(UIImageView *) image{
    UIWindow *view = [[UIApplication sharedApplication] keyWindow];
    // UIWindow * view =  [UIApplication sharedApplication].windows[0];
    self = [[NSBundle mainBundle]loadNibNamed:@"TPImageShow" owner:self options:nil][0];
    self.frame = view.frame;
    self.tag = customTag;
//    image.contentMode  = UIViewContentModeScaleAspectFit;
    _imageSmallData = imageSmallArr;
    _imageData = imagePathArr;
    _currentIndex = index;
    [_imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:imageCell];
    _imageCollectionView.dataSource = self;
    _imageCollectionView.delegate = self;
    [_imageCollectionView reloadData];
    _imageCollectionView.contentOffset= CGPointMake(self.width*index, 0);
        self.alpha = 0;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(tappedScrollView:)];
    [_imageCollectionView addGestureRecognizer:gesture];
    [view addSubview:self];
    

    return self;
}
-(void) tappedScrollView :(UITapGestureRecognizer *)tap{
    [self remove];
}
-(void)willMoveToWindow:(UIWindow *)newWindow{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        _imageCollectionView.hidden = NO;
        
    }];
    [super willMoveToWindow:newWindow];

}
-(void)remove{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        
    }];
}
#pragma mark - collectionview代理
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell * cell=  [collectionView dequeueReusableCellWithReuseIdentifier:imageCell forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSString * path= _imageData[row];
    NSString *smallPath = _imageSmallData[row];
    [cell boundImage:path smallPath:smallPath ];
//    [cell.selectImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kPhotoPath,path]]placeholderImage:[UIImage imageNamed:kDefaultPhoto1b1]];
     return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageData.count;
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    TPPriceCollectionViewCell * cell = (TPPriceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.textLabel.textColor =UserFontColor;
//    cell.selectImage.hidden = YES;
//    NSInteger row = indexPath.row;
//    NSMutableDictionary *rowdata =    _dataSource[row];
//    [rowdata removeObjectForKey:@"sel"];
//}
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.size;
}

@end
