//
//  ImageCollectionViewCell.m
//  blueberry
//
//  Created by 汤鹏 on 15-1-22.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "UIView+Extension.h"
#define SelectedColor RGBColorAlpha(242, 114, 36, 1)//选中的橘黄色
@implementation ImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
//        self.layer.borderColor = [[UIColor redColor] CGColor];
//        self.layer.borderWidth =1;        
        CGRect rect =CGRectMake(0, 0, frame.size.width, frame.size.height);
        _scroll = [[UIScrollView alloc]initWithFrame:rect];
        _scroll.showsHorizontalScrollIndicator=NO;
        _scroll.showsVerticalScrollIndicator=NO;
        _scroll.delegate=self;
         _selectImage = [[UIImageView alloc]initWithFrame:rect];
        _selectImage.contentMode =UIViewContentModeScaleAspectFit;
        [_scroll addSubview:_selectImage];
        [self addSubview:_scroll];
        _smallImage = [[UIImageView alloc]initWithFrame:rect];
        _smallImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_smallImage];
        _loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loading.color = SelectedColor;
        _loading.center =self.center;
        [self addSubview:_loading];
        
    }
    return self;
}
-(void) boundImage:(NSString *) path smallPath:(NSString *)smallPath{
    _smallImage.hidden=NO;
    [_loading startAnimating];
    if (smallPath) {
    [_smallImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",smallPath]]];
    }
    [_selectImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",path ]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_loading stopAnimating];
        if (!error) {
            _smallImage.hidden = YES;
            _scroll.zoomScale=1;
            CGSize size = image ? _selectImage.image.size : _selectImage.size;
            //比例
            CGFloat ratio = MIN(_scroll.width / size.width, _scroll.height / size.height);
            CGFloat nw = ratio * size.width;
            CGFloat nh = ratio * size.height;
            _selectImage.frame=  CGRectMake((_scroll.width - nw) / 2, (_scroll.height - nh) / 2, nw, nh);
            _scroll.minimumZoomScale =1;
            _scroll.maximumZoomScale=1/ratio;
        }
    }];
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _selectImage;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //让图片不会到处滚儿
    CGFloat Ws = scrollView.width - scrollView.contentInset.left - scrollView.contentInset.right;
    CGFloat Hs = scrollView.height - scrollView.contentInset.top - scrollView.contentInset.bottom;
    CGFloat W = _selectImage.width;
    CGFloat H = _selectImage.height;
    
    _selectImage.x = MAX((Ws-W)/2, 0);
    _selectImage.y = MAX((Hs-H)/2, 0);

}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}
@end
