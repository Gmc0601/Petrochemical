//
//  FactoryViews.m
//  BaseProject
//
//  Created by Jason on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FactoryViews.h"

@implementation FactoryViews
+ (UIButton *)CreatToolsButtonItemWithTitle:(NSString*)title andImage:(UIImage *)image andSelectedImage:(UIImage *)selectImage addTarget:(id)target action:(SEL)action{
    
    /* 获取按钮文字的宽度 获取按钮图片和文字的间距 获取图片宽度 */
    CGFloat    space = 5;// 图片和文字的间距
    
    CGFloat    titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    
    CGFloat    imageWidth = image.size.width;
    
    //UIButton   *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW / 3.0, 44)];
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, kScreenW / 3.0, 44);
    itemButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [itemButton setBackgroundColor:[UIColor clearColor]];
    [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itemButton setTitle:title forState:UIControlStateNormal];
    [itemButton setImage:image forState:UIControlStateNormal];
    [itemButton setImage:selectImage forState:UIControlStateSelected];
   
    [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
    [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    
    [itemButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return itemButton;
}
@end
