//
//  FactoryViews.h
//  BaseProject
//
//  Created by Jason on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryViews : NSObject
+ (UIButton *)CreatToolsButtonItemWithTitle:(NSString*)title andImage:(UIImage *)image andSelectedImage:(UIImage *)selectImage addTarget:(id)target action:(SEL)action;
@end
